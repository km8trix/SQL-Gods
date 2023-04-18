from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint('customers', __name__)

# Get customer detail for customer with particular userID
@customers.route('/customers/<userID>', methods=['GET'])
def get_customer(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Customer where custId = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer recommendations
@customers.route('/customers/<userID>/recommendations', methods=['GET'])
def get_customer_recommendations(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select showId, title AS Title, showDescription AS Description, showFormat AS Format, debutDate AS `Debut Date`, nextEpDate AS `Next Episode Date`, showStatus AS `Status`, runtime AS `Runtime` from Customer JOIN `Show To Customer` USING (custId) JOIN `Show` USING (showId) where custId = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all customers ids only from the DB
@customers.route('/customersids', methods=['GET'])
def get_customers_ids():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT CONCAT(firstname, ' ', lastname) as label, custId as value FROM Customer;")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get shows reviews
@customers.route('/shows/<userID>/reviews', methods=['GET'])
def get_show_reviews(userID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Review where showId = {0}'.format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get info on particular show
@customers.route('/shows/<showID>', methods=['GET'])
def get_show(showID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from `Show` where showId = {0}'.format(showID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all customers ids only from the DB
@customers.route('/showsids', methods=['GET'])
def get_shows_ids():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT title as label, showId as value FROM `Show`;")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get info on particular show
@customers.route('/shows/submit', methods=['POST'])
def add_new_show():
    req_data = request.get_json()

    show_id = req_data['showId']
    cust_id = req_data['custId']

    insert_stmt = 'INSERT INTO `Show To Customer` (showId, custId) VALUES ('
    insert_stmt += str(show_id) + ', ' + str(cust_id) + ')'

    cursor = db.get_db().cursor()
    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Success"

# Get info on particular show
@customers.route('/shows/delete', methods=['DELETE'])
def del_show():
    req_data = request.get_json()

    show_id = req_data['showId']
    cust_id = req_data['custId']

    delete_stmt = 'DELETE FROM `Show To Customer` WHERE showId = ' + str(show_id) + ' AND custId = ' + str(cust_id) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(delete_stmt)
    db.get_db().commit()
    return "Success"

# Get shows reviews
@customers.route('/shows/<userID>/reviews/edit/<reviewID>', methods=['PUT'])
def edit_show_review(userID, reviewID):
    req_data = request.get_json()

    description = req_data['reviewComment']
    cust_id = req_data['custId']
    review_id = req_data['reviewId']

    put_stmt = 'UPDATE Review SET reviewComment = ' + description + ' WHERE custId = ' + str(cust_id) + ' AND reviewId = ' + str(review_id) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(put_stmt)
    db.get_db().commit()
    return "Success"