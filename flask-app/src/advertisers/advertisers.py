from flask import Blueprint, request, jsonify, make_response
import json
from src import db


advertisers = Blueprint('advertisers', __name__)

# Get all advertisers from the DB
@advertisers.route('/advertisers/<advertiserID>', methods=['GET'])
def get_advertisers(advertiserID):
    cursor = db.get_db().cursor()

    cursor.execute('select advertiserId, advertiserName from Advertiser where advertiserId = {0}'.format(advertiserID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all ads from the DB
@advertisers.route('/ads', methods=['GET'])
def get_ads():
    query = '''
    SELECT adId, timeShown, clickCount, image, demoID, advertiserId from Ad
    '''
    cursor = db.get_db().cursor()
    

    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all advertiser's names and ids only from the DB
@advertisers.route('/advertisersids', methods=['GET'])
def get_advertisersids():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT advertiserName as label, advertiserId as value FROM Advertiser;")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get ad detail for ad with particular adId
@advertisers.route('/ads/<adID>', methods=['GET'])
def get_ad(adID):
    cursor = db.get_db().cursor()
    cursor.execute('select adId, timeShown, image, clickCount, demoID, advertiserId from Ad where adId = {0}'.format(adID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get ad detail for ads with particular adId's metrics
@advertisers.route('/ads/<adID>/metrics', methods=['GET'])
def get_ad_metrics(adID):
    cursor = db.get_db().cursor()
    cursor.execute('select adId, timeShown, image, clickCount, demoID, advertiserId from Ad where adId = {0}'.format(adID))
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
@advertisers.route('/shows/<userID>/reviews/edit/<reviewID>', methods=['PUT'])
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

