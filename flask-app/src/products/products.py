from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


products = Blueprint('products', __name__)

# Get all the products from the database
@products.route('/products', methods=['GET'])
def get_products():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT id, product_code, product_name, list_price FROM products')

    # grab the column headers from the returned data
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

@products.route('/product/<id>', methods=['GET'])
def get_product_detail (id):

    query = 'SELECT id, product_name, description, list_price, category FROM products WHERE id = ' + str(id)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(column_headers, row)))
    return jsonify(json_data)
    

# get the top 5 products from the database
@products.route('/mostExpensive')
def get_most_pop_products():
    cursor = db.get_db().cursor()
    query = '''
        SELECT product_code, product_name, list_price, reorder_level
        FROM products
        ORDER BY list_price DESC
        LIMIT 5
    '''
    cursor.execute(query)
    # grab the column headers from the returned data
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

@products.route('/tenMostExpensive', methods=['GET'])
def get_10_most_expensive_products():
    
    query = '''
        SELECT product_code, product_name, list_price, reorder_level
        FROM products
        ORDER BY list_price DESC
        LIMIT 10
    '''

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

@products.route('/product', methods=['POST'])
def add_new_product():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['product_name']
    description = the_data['product_description']
    price = the_data['product_price']
    category = the_data['product_category']

    # Constructing the query
    query = 'insert into products (product_name, description, category, list_price) values ("'
    query += name + '", "'
    query += description + '", "'
    query += category + '", '
    query += str(price) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    return 'Success!'

### Get all product categories
@products.route('/categories', methods = ['GET'])
def get_all_categories():
    query = '''
        SELECT DISTINCT category AS label, category as value
        FROM products
        WHERE category IS NOT NULL
        ORDER BY category
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

@products.route('/PaymentOptions/<Type>', methods = ['GET'])
def get_payment_options(UserID):
    query = '''
        SELECT DISTINCT Type
        FROM Payment_Option
        WHERE Type IN ('Credit Card', 'Debit Card', 'Cash on Delivery')'''
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

 ### Get all discount for all products 
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

@products.route('/editShippingMethod', methods=['PUT'])
def update_shipping_method():
    the_data = request.json
    
    current_id = the_data.get('ShippingOptionID')
    new_shipping = the_data.get('new_shipping')

    # update Payment Options
    the_query = 'UPDATE Shipping_Option SET Duration =' + str(new_shipping) + 'WHERE ShippingOptionID = ' + str(current_id)
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (new_shipping, current_id))   

    return "successfully editted paymentoption for#{0}!".format(current_id)
