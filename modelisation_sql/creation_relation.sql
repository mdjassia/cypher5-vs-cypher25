-- Table Location
CREATE TABLE Location (
    id_location SERIAL PRIMARY KEY,
    city VARCHAR(100) UNIQUE NOT NULL
);

-- Table Supplier
CREATE TABLE Supplier (
    id_supplier SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Location(id_location)
);

-- Table Client
CREATE TABLE Client (
    id_client SERIAL PRIMARY KEY,
    demographic VARCHAR(100) UNIQUE NOT NULL
);

-- Table Carrier
CREATE TABLE Carrier (
    id_carrier SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Table Route
CREATE TABLE Route (
    id_route SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Table Inspection
CREATE TABLE Inspection (
    id_inspection SERIAL PRIMARY KEY,
    result VARCHAR(100),
    defect_rate NUMERIC(5,2)
);

-- Table Product
CREATE TABLE Product (
    SKU VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50),
    price NUMERIC(10,2),
    availability INT,
    sold INT,
    revenue NUMERIC(12,2)
);

-- Table Supplier_Fournit_Product
CREATE TABLE Supplier_Product (
    supplier_id INT REFERENCES Supplier(id_supplier) ON DELETE CASCADE,
    product_sku VARCHAR(50) REFERENCES Product(SKU) ON DELETE CASCADE,
    lead_time INT,
    production_volume INT,
    manufacturing_cost NUMERIC(10,2),
    PRIMARY KEY (supplier_id, product_sku)
);

-- Table Product_Expedie_Carrier
CREATE TABLE Product_Carrier (
    product_sku VARCHAR(50) REFERENCES Product(SKU) ON DELETE CASCADE,
    carrier_id INT REFERENCES Carrier(id_carrier) ON DELETE CASCADE,
    shipping_time INT,
    shipping_cost NUMERIC(10,2),
    transport_mode VARCHAR(50),
    PRIMARY KEY (product_sku, carrier_id)
);

-- Table Carrier_Livre_Client
CREATE TABLE Carrier_Client (
    carrier_id INT REFERENCES Carrier(id_carrier) ON DELETE CASCADE,
    client_id INT REFERENCES Client(id_client) ON DELETE CASCADE,
    order_quantity INT,
    PRIMARY KEY (carrier_id, client_id)
);

-- Table Carrier_Emprunte_Route
CREATE TABLE Carrier_Route (
    carrier_id INT REFERENCES Carrier(id_carrier) ON DELETE CASCADE,
    route_id INT REFERENCES Route(id_route) ON DELETE CASCADE,
    route_cost NUMERIC(10,2),
    PRIMARY KEY (carrier_id, route_id)
);

-- Table Product_A_Resultat_Inspection
CREATE TABLE Product_Inspection (
    product_sku VARCHAR(50) REFERENCES Product(SKU) ON DELETE CASCADE,
    inspection_id INT REFERENCES Inspection(id_inspection) ON DELETE CASCADE,
    PRIMARY KEY (product_sku, inspection_id)
);
