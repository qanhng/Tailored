create database if not exist tailored;

grant all privileges on tailored.* to 'root'@'%';
flush privileges;

CREATE DATABASE Tailored;
USE Tailored;

CREATE TABLE IF NOT EXISTS Shipping_Option (
    ShippingOptionID int AUTO_INCREMENT PRIMARY KEY,
    Cost decimal(4, 2) NOT NULL,
    Duration varchar(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS Shopping_Cart(
    CartID int AUTO_INCREMENT PRIMARY KEY,
    Cost decimal(10,2) NOT NULL,
    ItemID int NOT NULL,
    ShippingOptionID int NOT NULL,
    FOREIGN KEY (ShippingOptionID) REFERENCES Shipping_Option(ShippingOptionID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS User(
    UserID int AUTO_INCREMENT PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    CartID int NOT NULL,
    FOREIGN KEY (CartID) REFERENCES Shopping_Cart(CartID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Persona(
    PersonaID int AUTO_INCREMENT PRIMARY KEY,
    Age int NOT NULL,
    Gender varchar(10) NOT NULL,
    StylePreference varchar(50) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Payment_Option(
    PaymentOptionID int AUTO_INCREMENT PRIMARY KEY,
    Type varchar(25) NOT NULL,
    CartID int NOT NULL,
    FOREIGN KEY(CartID) REFERENCES Shopping_Cart(CartID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Card_Info(
    CardNumber varchar(16) PRIMARY KEY,
    CVC int NOT NULL,
    NameOnCard varchar(100) NOT NULL,
    PaymentOptionID int NOT NULL,
    FOREIGN KEY (PaymentOptionID) REFERENCES Payment_Option(PaymentOptionID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Shipping_Info (
    ShippingInfoID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(50),
    Street varchar(75) NOT NULL,
    City varchar(75) NOT NULL,
    State char(2) NOT NULL,
    ZipCode char(5) NOT NULL,
    ShippingOptionID int,
    FOREIGN KEY (ShippingOptionID) REFERENCES Shipping_Option(ShippingOptionID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS ShippingInfo_User (
    UserID int NOT NULL,
    ShippingInfoID int NOT NULL,
    PRIMARY KEY (UserID, ShippingInfoID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (ShippingInfoID) REFERENCES Shipping_Info(ShippingInfoID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Notifications (
    NotificationID int AUTO_INCREMENT PRIMARY KEY,
    SubjectLine varchar(100) NOT NULL,
    Message text,
    TimeStamp datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS User_Notif (
    UserID int NOT NULL,
    NotificationID int NOT NULL,
    PRIMARY KEY (UserID, NotificationID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Wishlist (
    WishlistID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(75) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Category (
    CategoryID int AUTO_INCREMENT PRIMARY KEY,
    Material varchar(75),
    CategoryName varchar(75) NOT NULL
);

CREATE TABLE IF NOT EXISTS Discount (
    DiscountID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(75) NOT NULL,
    Amount decimal(10, 2) NOT NULL,
    Description text
);

CREATE TABLE IF NOT EXISTS Style (
    StyleID int AUTO_INCREMENT PRIMARY KEY,
    Color varchar(50) NOT NULL,
    AestheticName varchar(75) NOT NULL,
    TrendRating int NOT NULL CHECK (TrendRating BETWEEN 0 AND 10)
);

CREATE TABLE IF NOT EXISTS Brand (
    Name varchar(100) PRIMARY KEY,
    Rating int NOT NULL CHECK (Rating BETWEEN 0 AND 10),
    Type varchar(75) NOT NULL
);

CREATE TABLE IF NOT EXISTS Clothing_Item (
    ItemID int AUTO_INCREMENT PRIMARY KEY,
    Size varchar(3) NOT NULL,
    Name varchar(75) NOT NULL,
    Description text,
    Price decimal(10, 2) NOT NULL,
    DiscountID int,
    CategoryID int NOT NULL,
    CartID int,
    BrandName varchar(75) NOT NULL,
    StyleID int NOT NULL,
    FOREIGN KEY (DiscountID) REFERENCES Discount (DiscountID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CartID) REFERENCES Shopping_Cart (CartID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (BrandName) REFERENCES Brand (Name)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (StyleID) REFERENCES Style (StyleID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Purchase_History (
    PurchaseHistoryID int AUTO_INCREMENT PRIMARY KEY,
    PurchaseDate datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PurchaseCost decimal(10, 2) NOT NULL,
    PurchaseAesthetic varchar(75),
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Outfit (
    OutfitID int AUTO_INCREMENT PRIMARY KEY,
    Style varchar(75) NOT NULL,
    BodyFit varchar(75) NOT NULL,
    Price decimal(10, 2) NOT NULL,
    CostRating varchar(3),
    Name varchar(75) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PurchaseHistory_Outfit (
    PurchaseHistoryID int NOT NULL,
    OutfitID int NOT NULL,
    PRIMARY KEY (PurchaseHistoryID, OutfitID),
    FOREIGN KEY (PurchaseHistoryID) REFERENCES Purchase_History (PurchaseHistoryID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OutfitID) REFERENCES Outfit (OutfitID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Item_Outfit (
    ItemID int NOT NULL,
    OutfitID int NOT NULL,
    PRIMARY KEY (ItemID, OutfitID),
    FOREIGN KEY (ItemID) REFERENCES Clothing_Item (ItemID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OutfitID) REFERENCES Outfit (OutfitID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


/* Insert data */
INSERT INTO Shipping_Option (Cost, Duration)
VALUES (3.00, '7 Days'),
       (5.75, '4 Days');

INSERT INTO Shopping_Cart (Cost, ItemID, ShippingOptionID)
VALUES (59.99, 1, 1),
       (98.00, 2, 2);

INSERT INTO User (FirstName, LastName, CartID)
VALUES ('Amanda', 'Lee', 1),
       ('Siya', 'Patel', 2);

INSERT INTO Persona (Age, Gender, StylePreference, UserID)
VALUES (20, 'Female', 'Minimalist', 1),
       (43, 'Female', 'Luxury', 2);

INSERT INTO Payment_Option (Type, CartID)
VALUES ('Debit', 1),
       ('Credit', 2);

INSERT INTO Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID)
VALUES (8752765490232111, 300, 'AMANDA LEE', 1),
       (4234788799205688, 102, 'SIYA PATEL', 2);

INSERT INTO Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID)
VALUES ('Amanda', '1155 Tremont St', 'Boston', 'MA', '02120', 1),
       ('Siya Patel', '100 Grand Ave', 'Edison', 'NJ', '08827', 2);

INSERT INTO ShippingInfo_User (UserID, ShippingInfoID)
VALUES (1, 1),
       (2, 2);

INSERT INTO Notifications (SubjectLine, Message)
VALUES ('New Arrival!', 'Explore our dazzling new arrivals that redefine style and elevate your wardrobe.'),
       ('Delivery Update', 'Your order is on the way! Track your order here.');

INSERT INTO User_Notif (UserID, NotificationID)
VALUES (1, 2),
       (2, 1);

INSERT INTO Wishlist (Name, UserID)
VALUES ('My Wishlist', '1'),
       ('Christmas Wishlist', '2');

INSERT INTO Brand (Name, Rating, Type)
VALUES ('Urban Outfitters', 8, 'Lifestyle'),
       ('Aritzia', 9, 'Everyday Luxury');

INSERT INTO Style (Color, AestheticName, TrendRating)
VALUES ('Blue', 'Vintage', 8),
       ('Black', 'Quiet Luxury', 7);

INSERT INTO Category (CategoryName)
VALUES ('Sweater'),
       ('Dresses and Skirts'),
       ('Pants');

INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID)
VALUES ('Vintage', 'Classic Fit', 70.55, 5, 'Cozy Fall', 1),
       ('Minimalist', 'Slim Fit', 120.00, 7, 'Elegance', 2);

INSERT INTO Clothing_Item (Size, Name, Price, CategoryID, BrandName, StyleID)
VALUES ('L', 'Vintage Oversized Sweater', 59.99, 1, 'Urban Outfitters', 1),
       ('M', 'Slip Satin Maxi Skirt', 98.00, 2, 'Aritzia', 2);

INSERT INTO Item_Outfit (ItemID, OutfitID)
VALUES (1, 1),
       (2, 2);

INSERT INTO Discount (Name, Amount)
VALUES ('Black Friday Sale 40% Off', 0.6),
       ('20% Off Membership Deals', 0.8);

INSERT INTO Purchase_History (PurchaseCost, PurchaseAesthetic, UserID)
VALUES (65.00, 'Vintage', 1),
       (110.50, 'Quiet Luxury', 2);

INSERT INTO PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID)
VALUES (1, 1),
       (2, 2);