CREATE DATABASE IF NOT EXISTS pacs;
use pacs;

-- CREATE USER ADDRESS TABLE
CREATE TABLE user_address(
	address_id INT AUTO_INCREMENT PRIMARY KEY,
	street_no  VARCHAR(10) NOT NULL,
    street_name VARCHAR(20) NOT NULL,
    city VARCHAR(15) NOT NULL,
    state VARCHAR(15) NOT NULL,
    zip INT NOT NULL
);

-- CREATE USERS TABLE
CREATE TABLE user(
	username VARCHAR(20) PRIMARY KEY,
    user_password VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    address_id INT,
    CONSTRAINT address_id_fk FOREIGN KEY (address_id)
		REFERENCES user_address(address_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- CREATE PET BREEDS TABLE
CREATE TABLE pet_breed(
	breed_name VARCHAR(20) PRIMARY KEY,
    breed_description VARCHAR(100)
);

-- CREATE VET HOSPITAL TABLE
CREATE TABLE vet_hospital(
	hospital_name VARCHAR(50) PRIMARY KEY,
    hospital_street_no VARCHAR(10) NOT NULL,
    hospital_street_name VARCHAR(20) NOT NULL,
    hospital_city VARCHAR(15) NOT NULL,
    hospital_state VARCHAR(15) NOT NULL,
    hospital_zip VARCHAR(5) NOT NULL,
    hospital_contact_first_name VARCHAR(10) NOT NULL,
    hospital_contact_last_name VARCHAR(10) NOT NULL,
    hospital_contact_number VARCHAR(10) NOT NULL UNIQUE,
    CONSTRAINT hospital_unique_address UNIQUE(hospital_street_no, hospital_street_name,hospital_city,hospital_state,hospital_zip),
    CONSTRAINT hospital_unique_contact UNIQUE(hospital_contact_first_name,hospital_contact_last_name)
);

-- CREATE ANIMAL AGENCY TABLE
CREATE TABLE animal_agency(
	agency_name VARCHAR(50) PRIMARY KEY,
    agency_street_no VARCHAR(10) NOT NULL,
    agency_street_name VARCHAR(20) NOT NULL,
    agency_city VARCHAR(20) NOT NULL,
    agency_state VARCHAR(15) NOT NULL,
    agency_zip VARCHAR(5) NOT NULL,
    agency_contact_first_name VARCHAR(10) NOT NULL,
	agency_contact_last_name VARCHAR(10) NOT NULL,
    agency_contact_number VARCHAR(10) NOT NULL UNIQUE,
    CONSTRAINT agency_unique_address UNIQUE(agency_street_no, agency_street_name,agency_city,agency_state,agency_zip),
    CONSTRAINT agency_unique_contact UNIQUE(agency_contact_first_name,agency_contact_last_name)
);

-- CREATE AGENCY PARTNERED VET HOSPITALS
CREATE TABLE agency_partnered_vet_hospitals(
	agency_name VARCHAR(50) NOT NULL,
    hospital_name VARCHAR(50) NOT NULL,
    
    CONSTRAINT partnered_agency_fk FOREIGN KEY (agency_name)
		REFERENCES animal_agency(agency_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
	CONSTRAINT partnered_vet_fk FOREIGN KEY (hospital_name)
		REFERENCES vet_hospital(hospital_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- alter table agency_partnered_vet_hospitals
-- modify agency_name VARCHAR(50);

-- CREATE DOCTORS TABLE
CREATE TABLE doctor(
	doctor_id VARCHAR(10) PRIMARY KEY,
    doctor_first_name VARCHAR(20) NOT NULL,
    doctor_last_name VARCHAR(20) NOT NULL,
    degree VARCHAR(10),
    experience INT,
    works_at_hospital_name VARCHAR(50) NOT NULL,
    
    CONSTRAINT hospital_name_fk FOREIGN KEY (works_at_hospital_name)
		REFERENCES vet_hospital(hospital_name)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- CREATE PET TABLE
CREATE TABLE pet(
	pet_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_name VARCHAR(10) NOT NULL,
    pet_type ENUM('Dog','Cat','Bird','Rodents') NOT NULL,
    age INT NOT NULL,
    height INT NOT NULL,
    weight INT NOT NULL,
    color VARCHAR(10) NOT NULL,
    breed_name VARCHAR(20),
    adopted BOOLEAN NOT NULL,
    adopted_by VARCHAR(20),
    adoption_date DATE,
    provided_by_agency VARCHAR(20),
    
    CONSTRAINT breed_name_fk FOREIGN KEY (breed_name)
		REFERENCES pet_breed(breed_name)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
	
    CONSTRAINT provided_agency_fk FOREIGN KEY (provided_by_agency)
		REFERENCES animal_agency(agency_name)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
	
    CONSTRAINT adopted_by_fk FOREIGN KEY (adopted_by)
		REFERENCES user(username)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT check_adopted_false CHECK (adopted = 1 OR (adopted_by IS NULL AND adoption_date IS NULL)),
    CONSTRAINT check_adopted_true CHECK (adopted = 0 OR (adopted_by IS NOT NULL AND adoption_date IS NOT NULL))
);

-- ALTER TABLE pet
-- DROP CONSTRAINT check_adopted_false;

-- ALTER TABLE pet
-- DROP CONSTRAINT check_adopted_True;

-- ALTER TABLE pet
-- ADD CONSTRAINT check_adopted_false CHECK(adopted = 1 OR (adopted_by IS NULL AND adoption_date IS NULL));

-- ALTER TABLE pet
-- ADD CONSTRAINT check_adopted_True CHECK(adopted = 0 OR (adopted_by IS NOT NULL AND adoption_date IS NOT NULL));
--     

-- CREATE PET IMAGES TABLE
CREATE TABLE pet_image(
	image_id INT AUTO_INCREMENT PRIMARY KEY,
	image_url VARCHAR(500) NOT NULL,
    image_of_pet INT NOT NULL,
    
    CONSTRAINT pet_fk FOREIGN KEY (image_of_pet)
		REFERENCES pet(pet_id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE
);

-- CREATE USER COMMENTS ON PET TABLE
CREATE TABLE user_comment_pets(
	pet_id INT,
    username VARCHAR(20),
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_text VARCHAR(100),
    comment_date DATETIME,
    UNIQUE (pet_id,username,comment_id),
    CONSTRAINT pet_id_fk FOREIGN KEY (pet_id)
		REFERENCES pet(pet_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT user_fk FOREIGN KEY (username)
		REFERENCES user(username)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- CREATE USER INTERACTION TABLE
CREATE TABLE user_pet_interactions(
	username VARCHAR(20),
    pet_id INT,
    interaction_id INT AUTO_INCREMENT PRIMARY KEY,
    interaction_type ENUM('Play','Feed','Pet') NOT NULL,
	interaction_date DATE NOT NULL,
    interaction_start_time TIME,
    interaction_end_time TIME,
    
    CONSTRAINT interaction_pet_id_fk FOREIGN KEY (pet_id)
		REFERENCES pet(pet_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT interaction_user_fk FOREIGN KEY (username)
		REFERENCES user(username)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    
);

-- CREATE PET VISITS DOCTOR
CREATE TABLE pet_visit_doctor(
	pet_id INT,
    doctor_id VARCHAR(10),
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(100) NOT NULL,
    medications VARCHAR(50) NOT NULL,
    health_level ENUM('Great','Good','Moderate','Need Care') NOT NULL,
    CONSTRAINT doctor_visit_pet_id_fk FOREIGN KEY (pet_id)
		REFERENCES pet(pet_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT doctor_fk FOREIGN KEY (doctor_id)
		REFERENCES doctor(doctor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- INSERT TUPLES INTO TABLES
-- USER-ADDRESS TABLE
INSERT INTO user_address (street_no, street_name, city, state, zip) VALUES
('123', 'Main Street', 'New York', 'New York', 10001),
('456', 'Oak Avenue', 'Los Angeles', 'California', 90001),
('789', 'Maple Lane', 'Chicago', 'Illinois', 60601),
('101', 'Pine Street', 'Houston', 'Texas', 77001),
('202', 'Cedar Road', 'Phoenix', 'Arizona', 85001),
('303', 'Elm Boulevard', 'Philadelphia', 'Pennsylvania', 19101),
('404', 'Spruce Drive', 'San Antonio', 'Texas', 78201),
('505', 'Birch Lane', 'San Diego', 'California', 92101),
('606', 'Holly Street', 'Dallas', 'Texas', 75201),
('707', 'Sycamore Avenue', 'San Francisco', 'California', 94101);
 
-- USER TABLE 
INSERT INTO user (username, user_password, email, first_name, last_name, address_id) VALUES
('john_doe', 'password123', 'john.doe@email.com', 'John', 'Doe', 1),
('alice_smith', 'pass456', 'alice.smith@email.com', 'Alice', 'Smith', 2),
('bob_jones', 'secret789', 'bob.jones@email.com', 'Bob', 'Jones', 3),
('emma_white', 'emmaPass', 'emma.white@email.com', 'Emma', 'White', 4),
('mike_brown', 'mikePass', 'mike.brown@email.com', 'Mike', 'Brown', 5),
('sara_miller', 'saraPass', 'sara.miller@email.com', 'Sara', 'Miller', 6),
('david_clark', 'david123', 'david.clark@email.com', 'David', 'Clark', 7),
('linda_taylor', 'linda456', 'linda.taylor@email.com', 'Linda', 'Taylor', 8),
('chris_lee', 'chrisPass', 'chris.lee@email.com', 'Chris', 'Lee', 9),
('amy_wilson', 'amyPass', 'amy.wilson@email.com', 'Amy', 'Wilson', 10);

-- PET BREED TABLE

INSERT INTO pet_breed (breed_name, breed_description) VALUES
('beagle', 'Friendly, curious, and great with families'),
('german_shepherd', 'Intelligent, versatile, and loyal'),
('golden_retriever', 'Friendly and intelligent breed known for retrieving'),
('poodle', 'Highly intelligent and trainable dog breed'),
('bulldog', 'Docile, willful, and friendly'),
('siamese_cat', 'Distinctive short-haired breed with blue almond-shaped eyes'),
('persian_cat', 'Long-haired breed known for its distinctive appearance'),
('maine_coon', 'One of the largest domesticated cat breeds'),
('ragdoll', 'Known for its docile temperament and striking blue eyes'),
('bengal_cat', 'Distinctive spotted or marbled coat pattern'),
('parakeet', 'Small and colorful species of pet parrot'),
('cockatiel', 'Small, crested bird with a distinctive appearance'),
('budgerigar', 'Commonly known as the budgie, a small parakeet'),
('lovebird', 'Small, sociable birds that are often kept in pairs'),
('cockatoo', 'Large parrot with a distinctive crest'),
('hamster', 'Small, nocturnal rodent often kept as a pet'),
('guinea_pig', 'Social and docile rodent, popular as a companion animal'),
('rat', 'Intelligent and social animals often kept as pets'),
('gerbil', 'Small burrowing rodent with a long tail'),
('mouse', 'Small, intelligent rodents often kept in cages');


-- VET- HOSPITAL TABLE

INSERT INTO vet_hospital (
    hospital_name,
    hospital_street_no,
    hospital_street_name,
    hospital_city,
    hospital_state,
    hospital_zip,
    hospital_contact_first_name,
    hospital_contact_last_name,
    hospital_contact_number
) VALUES
('City Pets Clinic', '321', 'Oak Street', 'Urbanville', 'California', '90210', 'Alice', 'Johnson', 5551234567),
('Country Veterinary Care', '456', 'Maple Avenue', 'Ruraltown', 'Texas', '75001', 'John', 'Smith', 5559876543),
('Coastal Animal Hospital', '789', 'Palm Lane', 'Seaside', 'Florida', '33123', 'Emma', 'Taylor', 5552345678),
('Mountain View Vet Clinic', '101', 'Pine Road', 'Hillside', 'Colorado', '80302', 'Michael', 'Brown', 5558765432),
('Paws and Claws Veterinary', '202', 'Cedar Street', 'Woodland', 'Washington', '98101', 'Sophia', 'Miller', 5553456789),
('Golden State Animal Hospital', '303', 'Redwood Boulevard', 'Valley City', 'California', '94566', 'Ethan', 'Clark', 5557654321),
('Riverfront Pet Clinic', '404', 'Birch Lane', 'Riverside', 'Oregon', '97201', 'Olivia', 'Garcia', 5552345679),
('Skyline Veterinary Center', '505', 'Spruce Drive', 'Mountainview', 'Arizona', '85001', 'William', 'Anderson', 5556543210),
('Harborview Animal Hospital', '606', 'Sycamore Avenue', 'Harbor City', 'New York', '10001', 'Ava', 'Turner', 5554321098),
('Sunset Pet Care', '707', 'Lakeside Drive', 'Sunset Beach', 'Florida', '33706', 'Logan', 'White', 5558901234);

-- ANIMAL AGENCY TABLE

INSERT INTO animal_agency (
    agency_name,
    agency_street_no,
    agency_street_name,
    agency_city,
    agency_state,
    agency_zip,
    agency_contact_first_name,
    agency_contact_last_name,
    agency_contact_number
) VALUES
('Happy Paws Rescue', '123', 'Sunset Avenue', 'Sunsetville', 'California', '90210', 'Emily', 'Johnson', '5551234567'),
('Wildlife Haven', '456', 'Forest Lane', 'Naturetown', 'Texas', '75001', 'Daniel', 'Smith', '5559876543'),
('Feathered Friends Sanctuary', '789', 'Skyline Drive', 'Aviaryville', 'Florida', '33123', 'Isabella', 'Taylor', '5552345678'),
('Critter Care Center', '101', 'Meadow Road', 'Woodland Hills', 'Colorado', '80302', 'Nicholas', 'Brown', '5558765432'),
('Aquatic Wonders Rescue', '202', 'Coral Street', 'Seaside', 'Oregon', '97201', 'Hannah', 'Miller', '5553456789'),
('Purrfect Companions', '303', 'Whisker Lane', 'Feline City', 'New York', '10001', 'Elijah', 'Clark', '5557654321'),
('Scales and Tails Haven', '404', 'Reptile Road', 'Herpetopolis', 'Arizona', '85001', 'Grace', 'Garcia', '5552345679'),
('Horse Haven Ranch', '505', 'Stable Drive', 'Equestrian Meadows', 'Kentucky', '40202', 'Oliver', 'Anderson', '5556543210'),
('Bunny Bliss Shelter', '606', 'Bunny Lane', 'Rabbitville', 'Ohio', '44101', 'Sophie', 'Turner', '5554321098'),
('Critter Cove Rescue', '707', 'Harbor View Road', 'Marine Haven', 'California', '92614', 'Lucas', 'White', '5558901234');


-- AGENCY_PARTNERED_VET_HOSPITALS TABLE
INSERT INTO agency_partnered_vet_hospitals (agency_name, hospital_name) VALUES 
('Happy Paws Rescue', 'City Pets Clinic'),
('Wildlife Haven', 'Country Veterinary Care'),
('Feathered Friends Sanctuary', 'Coastal Animal Hospital'),
('Critter Care Center', 'Mountain View Vet Clinic'),
('Aquatic Wonders Rescue', 'Paws and Claws Veterinary');

-- DOCTOR TABLE
INSERT INTO doctor (doctor_id, doctor_first_name, doctor_last_name, degree, experience, works_at_hospital_name) 
VALUES ('D001', 'John', 'Smith', 'DVM', 5, 'City Pets Clinic'),
       ('D002', 'Emily', 'Jones', 'VMD', 8, 'City Pets Clinic'),
       ('D003', 'Daniel', 'Miller', 'DVM', 3, 'Country Veterinary Care'),
	   ('D004', 'Emma', 'Wilson', 'VMD', 6, 'Coastal Animal Hospital'),
       ('D005', 'Nicholas', 'Taylor', 'DVM', 4, 'Mountain View Vet Clinic'),
       ('D006', 'Sophia', 'Brown', 'VMD', 7, 'Mountain View Vet Clinic');
       
-- PET TABLE
INSERT INTO pet (pet_name, pet_type, age, height, weight, color, breed_name, adopted, adopted_by, adoption_date, provided_by_agency)
VALUES
('Buddy', 'Dog', 3, 12, 25, 'Brown', 'beagle', False, NULL, NULL, 'Happy Paws Rescue'),
('Luna', 'Cat', 2, 8, 10, 'Gray', 'persian_cat', True, 'john_doe', '2023-01-15', 'Wildlife Haven'),
('Kiwi', 'Bird', 1, 6, 0.5, 'Green', 'lovebird', False, NULL, NULL, 'Happy Paws Rescue'),
('Nibbles', 'Rodents', 1, 4, 0.2, 'White', 'guinea_pig', False, NULL, NULL, 'Wildlife Haven'),
('Max', 'Dog', 4, 15, 30, 'Golden', 'golden_retriever', True, 'alice_smith', '2022-11-05', 'Happy Paws Rescue');

-- USER-COMMENT-PETS TABLE
INSERT INTO user_comment_pets (pet_id, username, comment_text, comment_date)
VALUES
(1, 'john_doe', 'Buddy is such an energetic and friendly dog!', '2023-01-20 08:30:00'),
(2, 'alice_smith', 'Luna is the sweetest cat ever!', '2023-01-21 10:45:00'),
(1, 'john_doe', 'Buddy loves going for long walks in the park.', '2023-01-22 15:20:00'),
(2, 'alice_smith', 'Luna enjoys cuddling and purring.', '2023-01-23 12:10:00'),
(3, 'emma_white', 'Kiwi chirps happily every morning!', '2023-01-24 09:05:00'),
(4, 'mike_brown', 'Nibbles is a curious little rodent!', '2023-01-25 14:30:00'),
(5, 'sara_miller', 'Max, the Golden Retriever, is very playful!', '2023-01-26 11:15:00');

-- USER-INTERACT-PETS TABLE
INSERT INTO user_pet_interactions (username, pet_id, interaction_type, interaction_date, interaction_start_time, interaction_end_time)
VALUES
('john_doe', 1, 'Play', '2023-01-20', '10:00:00', '10:30:00'),
('alice_smith', 2, 'Feed', '2023-01-21', '12:45:00', '13:15:00'),
('emma_white', 3, 'Pet', '2023-01-22', '15:30:00', '16:00:00'),
('mike_brown', 4, 'Play', '2023-01-23', '11:00:00', '11:30:00'),
('sara_miller', 5, 'Feed', '2023-01-24', '09:30:00', '10:00:00'),
('john_doe', 1, 'Pet', '2023-01-25', '14:00:00', '14:30:00'),
('alice_smith', 2, 'Play', '2023-01-26', '16:30:00', '17:00:00'),
('emma_white', 3, 'Feed', '2023-01-27', '12:00:00', '12:30:00'),
('mike_brown', 4, 'Pet', '2023-01-28', '13:45:00', '14:15:00'),
('sara_miller', 5, 'Play', '2023-01-29', '10:30:00', '11:00:00');

-- PET-VISIT-DOCTOR TABLE
-- Assuming 'Buddy' and 'Luna' are present in the 'pet' table
-- Assuming 'D001' and 'D002' are present in the 'doctor' table

INSERT INTO pet_visit_doctor (pet_id, doctor_id, visit_date, diagnosis, medications, health_level)
VALUES
(1, 'D001', '2023-01-10', 'Routine checkup, all parameters normal', 'None', 'Great'),
(2, 'D002', '2023-01-15', 'Minor cough and sneezing', 'Prescribed antibiotics', 'Good'),
(1, 'D001', '2023-02-05', 'Limping on right hind leg', 'Prescribed pain relievers', 'Moderate'),
(2, 'D002', '2023-02-12', 'Healthy and active', 'None', 'Great'),
(3, 'D001', '2023-03-20', 'Feathers appear dull, possible nutrient deficiency', 'Prescribed avian supplement', 'Moderate'),
(4, 'D002', '2023-04-02', 'Small wound on tail, cleaned and bandaged', 'Prescribed topical ointment', 'Good');
