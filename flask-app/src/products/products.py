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
@products.route('/Discounts/<Amount>', methods = ['GET'])
def get_amount():
    query = '''
        SELECT Amount 
        FROM Discount JOIN Clothing_Item ON Discount.DiscountID = Clothing_Item.DiscountID
        WHERE Clothing_Item.DiscountID IS NOT NULL
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


@products.route('/ShoppingCart/<CartID>', methods = ['GET'])
def get_shoppingcart(UserID):
    query = '''
        SELECT CI.ItemID, CI.Name, CI.Description, CI.Price, CI.Size
        FROM Shopping_Cart SC
        JOIN Clothing_Item CI ON SC.CartID = CI.CartID
        JOIN User U ON SC.CartID = U.CartID
        WHERE U.UserID = {0}'''.format(UserID)
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
    SELECT b.Type, b.Rating
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

@products.route('/ShoppingCart', methods=['POST'])
def add_new_shopping():
    # Collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # Extracting the variables
    ItemID = the_data['ItemID']
    price = the_data['Price']

    # Constructing the parameterized query
    query = 'INSERT INTO Shopping_Cart (Cost, ItemID) VALUES (%s, %s, %s, %s)'
    values = (price, ItemID, 1)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, values)
    db.get_db().commit()

    return 'Success!'

@products.route('/ShoppingCart/<userID>', methods=['GET'])
def get_shopping_cart_info(userID):
    query = '''SELECT SC.ItemID, SC.CartID, CI.Name, CI.Price, U.UserID
        FROM Shopping_Cart SC
        JOIN Clothing_Item CI ON SC.CartID = CI.CartID
        JOIN User U ON SC.CartID = U.CartID
        JOIN ShippingInfo_User SIU on U.UserID = SIU.UserID
        JOIN Shipping_Info SI on SIU.ShippingInfoID = SI.ShippingInfoID
        JOIN Shipping_Option SO on SC.ShippingOptionID = SO.ShippingOptionID
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