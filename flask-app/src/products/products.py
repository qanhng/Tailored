from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


products = Blueprint('products', __name__)

### Gets the outfit 
@products.route('/outfit/<userID>', methods = ['GET'])
def get_outfit(userID):
    query = '''
        SELECT O.Style, O.BodyFit, O.Price, O.CostRating, O.Name
        FROM Outfit O JOIN User U on O.UserID = U.UserID
        WHERE O.UserID =   ''' + str(userID)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)

### Gets clothing items 
@products.route('/ClothingItem/<userID>', methods = ['GET'])
def get_clothingitem(userID):

    query = '''
        SELECT CI.Name, CI.Price, CI.Description, CI.Brandname, CI.ItemID
        FROM Outfit O JOIN User U on O.UserID = U.UserID
        Join Tailored.Item_Outfit I on O.OutfitID = I.OutfitID
        JOIN Tailored.Clothing_Item CI on CI.ItemID = I.ItemID
        WHERE O.UserID =  ''' + str(userID)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)


### Get all discount for all products 
@products.route('/Discounts/<itemID>', methods = ['GET'])
def get_discount(itemID):
    query = '''
        SELECT Amount AS Discount_Price
        FROM Discount JOIN Clothing_Item ON Discount.DiscountID = Clothing_Item.DiscountID
        WHERE Clothing_Item.ItemID = ''' + str(itemID)

    cursor = db.get_db().cursor()
    cursor.execute(query)

    json_data = []
    # fetch all the column headers and then all the data from the cursor
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    # zip headers and data together into dictionary and then append to json data dict.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)

### Get the brand of the item 
@products.route('/Brand/<itemid>', methods = ['GET'])
def get_brand(itemid):
    query = '''
    SELECT b.Type, b.Rating, b.Name
    FROM Clothing_Item ci
    JOIN  Brand b ON ci.BrandName = b.Name
    WHERE ci.ItemID = ''' + str(itemid)
    cursor = db.get_db().cursor()
    cursor.execute(query)
    json_data = []
    # fetch all the column headers and then all the data from the cursor
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    # zip headers and data together into dictionary and then append to json data dict.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)

### Get Style Rating on the Product
@products.route('/Style/<itemID>', methods=['GET'])
def get_style(itemID):
    query = '''SELECT S.Color, S.AestheticName, S.TrendRating
            FROM Clothing_Item CI JOIN Style S ON CI.StyleID = S.StyleID
            WHERE CI.ItemID = ''' + str(itemID)
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

 ### Get all Notifications for all deals 
@products.route('/Notification', methods = ['GET'])
def get_notifications():
    query = '''
        SELECT *
        FROM Notifications;
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    json_data = []
    # fetch all the column headers and then all the data from the cursor
    column_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    # zip headers and data together into dictionary and then append to json data dict.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    
    return jsonify(json_data)


### Gets the categories of the product 
@products.route('/Categories/<itemID>', methods=['GET'])
def get_categories(itemID):
    query = '''SELECT CI.Name, C.CategoryName, C.Material
            FROM Clothing_Item CI JOIN Category C ON CI.CategoryID = C.CategoryID
            WHERE CI.ItemID = ''' + str(itemID)
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

### Get Shopping Cart info 
@products.route('/ShoppingCart/<userID>', methods=['GET'])
def get_shopping_cart_info(userID):
    query = '''SELECT CI.ItemID, CI.Name, CI.BrandName, CI.Size, CI.Price
    FROM Shopping_Cart SC
        JOIN ShoppingCart_Item ON SC.CartID = ShoppingCart_Item.CartID
        JOIN Tailored.Clothing_Item CI on CI.ItemID = ShoppingCart_Item.ItemID
        JOIN Tailored.User U on SC.UserID = U.UserID
    WHERE U.UserID =''' + str(userID)
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

### Get total price of the Shopping Cart 
@products.route('/ShoppingCartPrice/<userID>', methods=['GET'])
def get_total_price(userID):
    query = '''SELECT SUM(CI.Price) AS Cart_Total FROM Shopping_Cart SC
        JOIN ShoppingCart_Item ON SC.CartID = ShoppingCart_Item.CartID
        JOIN Tailored.Clothing_Item CI on CI.ItemID = ShoppingCart_Item.ItemID
        JOIN Tailored.User U on SC.UserID = U.UserID
    WHERE U.UserID =''' + str(userID)
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

### Adds item to Shopping cart 
@products.route('/addShoppingItems', methods=['POST'])
def add_new_shopping_cart_items():
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    userID = the_data['User']
    itemID = the_data['Cart_Item']

    # Constructing the query
    query = 'INSERT INTO ShoppingCart_Item(CartID, ItemID) VALUES (%s, %s)'
    values = (userID, itemID)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Success!'

### Deletes Item from Shopping Cart
@products.route('/DeleteCartItem/<userID>', methods=['DELETE'])
def delete_cart_item(userID):

    the_data = request.json
    current_app.logger.info(the_data)
    deleted_id = the_data.get('Delete_ID')

    # Constructing the delete query
    query = '''DELETE FROM ShoppingCart_Item
            WHERE ItemId = ''' + str(deleted_id) + ''' and CartID = ''' + str(userID)

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Item deleted successfully!'

# gets the shipping option duration for the customer
@products.route('/shippingOptions/<userID>', methods = ['GET'])
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

# gets all possible shipping options for all customers
@products.route('/allShippingOptions', methods = ['GET'])
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


@products.route('/editShippingMethod', methods=['PUT'])
def update_shipping_method():
    the_data = request.json
    
    current_id = the_data.get('ShippingOptionID')
    new_shipping = the_data.get('new_shipping')

    # update Payment Options
    the_query = 'UPDATE Shipping_Option SET Duration = %s WHERE ShippingOptionID = %s' 
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (new_shipping,current_id)) 
    db.get_db().commit()


    return "successfully editted shipping option for#{0}!".format(current_id)
