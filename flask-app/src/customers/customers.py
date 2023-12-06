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

@customers.route('/wishlist/<userid>', methods=['GET'])
def get_wishlist(userid):
    cursor = db.get_db().cursor()
    query= '''SELECT CI.ItemID, CI.Name AS ItemName, CI.Description, CI.Price, CI.Size, CI.BrandName, CI.StyleID
            FROM Wishlist W
            JOIN Wishlist_Item WI ON W.WishlistID = WI.WishlistID
            JOIN Clothing_Item CI ON CI.ItemID = WI.ItemID
            JOIN User U ON U.UserID = W.WishlistID
            WHERE U.UserID = ''' + str(userid)
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



@customers.route('/Wishlist_Item/<userID>', methods=['DELETE'])
def delete_wishlist_item(userID):
    the_data = request.json
    
    deleted_id = the_data.get('Wanted_id')

    # Constructing the delete query
    query = '''DELETE FROM Wishlist_Item
            WHERE ItemId = ''' + str(deleted_id) + ''' and WishlistID = ''' + str(userID)

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Item deleted successfully!'

@customers.route('/wishlistItems', methods=['POST'])
def add_new_wishlist_information():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    userID = the_data['User']
    itemID = the_data['Wishlist_Item']

    # Constructing the query
    query = 'INSERT INTO Wishlist_Item (WishlistID, itemID) VALUES (%s, %s)'
    values = (userID, itemID)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
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

    # update Payment Options
    the_query = 'UPDATE Payment_Option SET Type = %s WHERE CartID = %s'
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (new_type, userID))   

    return "successfully editted paymentoption for#{0}!".format(userID)


@customers.route('/shippingOptions/<userID>', methods = ['GET'])
def get_shipping_options(userID):
    query = '''SELECT SO.Duration, SO.Cost, SO.ShippingOptionID, SI.Name, SI.City, SI.State, SI.Street, SI.ZipCode
     FROM Shipping_Option SO  JOIN Shipping_Info SI on SO.ShippingOptionID = SI.ShippingOptionID
        JOIN ShippingInfo_User SIU ON SI.ShippingInfoID = SIU.ShippingInfoID JOIN User U on SIU.UserID = U.UserID
        WHERE U.UserID =  ''' + str(userID)
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

@customers.route('/allShippingOptions', methods = ['GET'])
def get_all_shipping_options():
    query = '''SELECT DISTINCT SO.Duration FROM Shipping_Option SO'''
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


@customers.route('/editShippingMethod', methods=['PUT'])
def update_shipping_method():
    the_data = request.json
    
    current_id = the_data.get('ShippingOptionID')
    new_shipping = the_data.get('new_shipping')

    # update Payment Options
    the_query = 'UPDATE Shipping_Option SET Duration =' + str(new_shipping) + 'WHERE ShippingOptionID = ' + str(current_id)
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (new_shipping, current_id))   

    return "successfully editted paymentoption for#{0}!".format(current_id)


@customers.route('/shoppingItems', methods=['POST'])
def add_new_shopping_cart():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    userID = the_data['User']
    itemID = the_data['Cart_Item']

    # Constructing the query
    query = 'INSERT INTO Wishlist_Item (WishlistID, itemID) VALUES (%s, %s)'
    values = (userID, itemID)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Success!'

@customers.route('/wishlistID/<userid>', methods=['GET'])
def get_wishlist_id(userid):
    cursor = db.get_db().cursor()
    query= '''SELECT CI.ItemID
            FROM Wishlist W
            JOIN Wishlist_Item WI ON W.WishlistID = WI.WishlistID
            JOIN Clothing_Item CI ON CI.ItemID = WI.ItemID
            JOIN User U ON U.UserID = W.WishlistID
            WHERE U.UserID = ''' + str(userid)
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