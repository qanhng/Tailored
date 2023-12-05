from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('select company, last_name,\
        first_name, job_title, business_phone from customers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer detail for customer with particular userID
@customers.route('/customers/<userID>', methods=['GET'])
def get_customer(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT U.UserID, U.FirstName, U.LastName, P.Gender, P. StylePreference, P.Age FROM User U JOIN Persona P on P.UserID = U.UserID WHERE P.UserID = ' + str(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@customers.route('/wishlist/<userID>', methods=['GET'])
def get_wishlist(userID):
    cursor = db.get_db().cursor()
    query= '''SELECT CI.ItemID, CI.Name AS ItemName, CI.Description, CI.Price, CI.Size, CI.BrandName, CI.StyleID
            FROM Wishlist W
            JOIN Clothing_Item CI ON W.WishlistID = CI.CartID
            JOIN User U ON W.UserID = U.UserID
            WHERE U.UserID = ''' + str(userID)
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

@customers.route('/ShippingOptions', methods=['GET'])
def get_shipping_option(UserID):
    cursor = db.get_db().cursor()
    query= '''SELECT 
            SC.CartID,SC.Cost AS CartCost, SO.ShippingOptionID, SO.Cost AS ShippingCost, SO.Duration
            FROM Shopping_Cart SC JOIN Shipping_Option SO ON SC.ShippingOptionID = SO.ShippingOptionID
            JOIN User U ON SC.CartID = U.CartID
            WHERE U.UserID = {0}'''.format(UserID)
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

@customers.route('/customers/PurchaseHistories/<PurchaseAesthetic>', methods=['GET'])
def get_purchaseAesthetic(UserID):
    query = 'SELECT PH.PurchaseAesthetic \
            FROM Purchase_History PH JOIN User U ON PH.UserID = U.UserID \
            JOIN Persona P ON U.UserID = P.UserID \
            JOIN Style S ON P.StylePreference = S.AestheticName \
            WHERE U.UserID = {0}'.format(UserID)

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

@customers.route('/user', methods=['GET'])
def get_all_users():
    query = '''SELECT UserID FROM User'''
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

@customers.route('/user/Wishlist_Item/<ItemID>', methods=['DELETE'])
def delete_wishlist_item(ItemID):
    # Collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # Constructing the delete query
    query = 'DELETE FROM Wishlist_Item WHERE ItemID = {0}'.format(ItemID)

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Item deleted successfully!'

@customers.route('/user', methods=['POST'])
def add_new_wishlist():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['Name']
    userID = the_data['UserID']

    # Constructing the query
    query = 'INSERT INTO Wishlist (Name, UserID) VALUES (%s, %s, %s)'
    values = (name, userID, 1)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'