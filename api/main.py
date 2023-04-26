import json
# import re
import smtplib
import ssl
import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
from firebase_admin import storage
# import functions_framework


app = Flask(__name__)
CORS(app)

# Initialize the firebase Admin SDK
cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Get a reference to the firestore database
database = firestore.client()


@app.route('/users', methods=['POST'])
def create_profile():
    record = json.loads(request.data)
    id = record['stu_id']
    stu_ref = database.collection('users').document(id)

    # required fields needed to be submitted 
    field_data = ["stu_id", "name", "email", "DOB", "year_grp", "major",
            "residence", "fav_food", "fav_movie"]
    # email_pattern =  r"^([a-z]+[\.]?[a-z]+)@(ashesi\.edu\.gh|aucampus\.onmicrosoft\.com)$"
    
    # check if fields are available
    for field in field_data:
        if record.get(field) is None:
            return jsonify({"message": f"{field} is required"}), 404

    # checking for duplicates
    if stu_ref.get().exists:
        return jsonify({"error": "User already exists"}), 409
    else:
        stu_ref.set(record)
    return jsonify({"message": "Successful registration"})


@app.route('/users', methods=['PATCH'])
def edit_profile():
    record = request.get_json()
    id = record['stu_id']
    # pulling up all fields that can be updated
    new_dob = record.get('DOB')
    new_year = record.get('year_grp')
    new_major = record.get('major')
    new_residence = record.get('residence')
    new_food = record.get('fav_food')
    new_movie = record.get('fav_movie')

    stu_ref = database.collection('users').document(id)

    if stu_ref.get().exists:
        # update the following fields only if the result from the query has a value
        if new_dob is not None:
            stu_ref.update({'DOB': new_dob})
        if new_year is not None:
            stu_ref.update({'year_grp': new_year})
        if new_major is not None:
            stu_ref.update({'major': new_major})
        if new_residence is not None:
            stu_ref.update({'residence': new_residence})
        if new_food is not None:
            stu_ref.update({'fav_food': new_food})
        if new_movie is not None:
            stu_ref.update({'fav_movie': new_movie})
        
        return jsonify({"message": "Updated successfully"})
    return jsonify({"error": "User not found"}), 404


@app.route('/users/<id>', methods=['GET'])
def view_profile(id):
    stu_ref = database.collection('users').document(id)
    student = stu_ref.get() #retrieve user information

    if student.exists:
        return jsonify(student.to_dict())
    return jsonify({"error" : "User doesn't exist"}), 404


@app.route('/posts', methods=['POST'])
def create_post():
    record = request.get_json()

    user_email = record['email']
    
    user_ref = database.collection('users').where('email', '==', user_email).get()
    if len(user_ref) > 0:
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        record['timestamp'] = timestamp
        database.collection('posts').add(record)
        send_email(user_email)
    else:
        return jsonify({'error': 'User does not exist, post not created'}), 404
    return jsonify({'message': 'Post created successfully'})


def get_mailing_list(user_email):
    """
    Function to return the emails of all users
    """
    users = database.collection('users').get()

    mailing_list = []
    for user in users:
        user_ref = user.to_dict()
        if user_ref['email'] == user_email:
            continue
        else:
            mailing_list.append(user_ref['email'])

    return mailing_list


def send_email(user_email):
    # seting up the smtp server, secure content and credentials
    smtp = "smtp.office365.com"
    port = 587
    contxt = ssl.create_default_context()
    sender_email = "linkup_ashesi@outlook.com"
    sender_password = "Link@pp!"

    # get mailing list of users
    recipients = get_mailing_list(user_email)

    # compose the email
    message = MIMEMultipart()
    message['From'] = sender_email
    message['Bcc'] = ", ".join(recipients)
    message['Subject'] = "New post alert"
    body = f"Dear Linker, \nLinker {user_email} has made a new post in LinkUp. Login to view\n\nSincerly,\nLinkUp"
    message.attach(MIMEText(body, 'plain'))

    # send the email
    with smtplib.SMTP(smtp, port) as server:
        server.starttls(context=contxt)
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, recipients, message.as_string())




if __name__ == "__main__":
    app.run()