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
def get_wishlist(itemID):
    cursor = db.get_db().cursor()
    query= '''SELECT CI.ItemID, CI.Name AS ItemName, CI.Description, CI.Price, CI.Size, CI.BrandName, CI.StyleID
            FROM Wishlist W
            JOIN Wishlist_Item WI ON W.WishlistID = WI.WishlistID
            JOIN Clothing_Item CI ON CI.ItemID = WI.ItemID
            WHERE CI.ItemID = ''' + str(itemID)
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
def delete_wishlist_item(ItemID, UserID):
    # Constructing the delete query
    query = 'DELETE \
            FROM Wishlist_Item \
            WHERE WishlistID = ' + str(UserID), 'ItemID = ' + str(ItemID)

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
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

@customers.route('/paymentOptions/<userID>', methods = ['GET'])
def get_payment_options(userID):
    query = '''Select PO.Type, PO.CartID From Payment_Option PO JOIN Tailored.Shopping_Cart SC on PO.CartID = SC.CartID
    JOIN Tailored.User U on SC.CartID = U.CartID
    WHERE U.UserID = ''' + str(userID)
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

@customers.route('/possiblePaymentOptions', methods = ['GET'])
def get_possible_payment_options():
    query = 'SELECT DISTINCT PO.Type from Payment_Option PO'
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

@customers.route('/editPaymentOption/<userID>', methods=['PUT'])
def update_payment_method(userID):
    the_data = request.json
    
    new_type = the_data.get('new_type')
    
    # grab cart id and previous data needed
    paymentInfo = get_payment_options(userID)
    
    numID = str(paymentInfo['CartID'])
    prev_type = str(paymentInfo['Type'])

    # update Payment Options
    the_query = 'UPDATE Payment_Option SET Type =  ' + str(new_type) + ' WHERE CartID = ' + str(numID) + ';'
    
    cursor = db.get_db().cursor()
    cursor.execute(the_query)
    db.get_db().commit()

    return "successfully editted paymentoption for#{0}!".format(userID)
