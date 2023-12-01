from pacs import db

class UserAddress(db.Model):
    address_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    street_no = db.Column(db.String(10), nullable=False)
    street_name = db.Column(db.String(20), nullable=False)
    city = db.Column(db.String(15), nullable=False)
    state = db.Column(db.String(15), nullable=False)
    zip = db.Column(db.Integer, nullable=False)

class User(db.Model):
    username = db.Column(db.String(20), primary_key=True)
    user_password = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    first_name = db.Column(db.String(20), nullable=False)
    last_name = db.Column(db.String(20), nullable=False)
    address_id = db.Column(db.Integer, db.ForeignKey('user_address.address_id'), nullable=False)
    address = db.relationship('UserAddress', backref='user')

class PetBreed(db.Model):
    breed_name = db.Column(db.String(20), primary_key=True)
    breed_description = db.Column(db.String(100))

class VetHospital(db.Model):
    hospital_name = db.Column(db.String(50), primary_key=True)
    hospital_street_no = db.Column(db.String(10), nullable=False)
    hospital_street_name = db.Column(db.String(20), nullable=False)
    hospital_city = db.Column(db.String(15), nullable=False)
    hospital_state = db.Column(db.String(15), nullable=False)
    hospital_zip = db.Column(db.String(5), nullable=False)
    hospital_contact_first_name = db.Column(db.String(10), nullable=False)
    hospital_contact_last_name = db.Column(db.String(10), nullable=False)
    hospital_contact_number = db.Column(db.String(10), nullable=False, unique=True)

class AnimalAgency(db.Model):
    agency_name = db.Column(db.String(50), primary_key=True)
    agency_street_no = db.Column(db.String(10), nullable=False)
    agency_street_name = db.Column(db.String(20), nullable=False)
    agency_city = db.Column(db.String(20), nullable=False)
    agency_state = db.Column(db.String(15), nullable=False)
    agency_zip = db.Column(db.String(5), nullable=False)
    agency_contact_first_name = db.Column(db.String(10), nullable=False)
    agency_contact_last_name = db.Column(db.String(10), nullable=False)
    agency_contact_number = db.Column(db.String(10), nullable=False, unique=True)

class AgencyPartneredVetHospital(db.Model):
    agency_name = db.Column(db.String(50), db.ForeignKey('animal_agency.agency_name'), primary_key=True)
    hospital_name = db.Column(db.String(50), db.ForeignKey('vet_hospital.hospital_name'), primary_key=True)
    agency = db.relationship('AnimalAgency', backref='partnered_vet_hospitals')
    hospital = db.relationship('VetHospital', backref='partnered_agencies')

class Doctor(db.Model):
    doctor_id = db.Column(db.String(10), primary_key=True)
    doctor_first_name = db.Column(db.String(20), nullable=False)
    doctor_last_name = db.Column(db.String(20), nullable=False)
    degree = db.Column(db.String(10))
    experience = db.Column(db.Integer)
    works_at_hospital_name = db.Column(db.String(50), db.ForeignKey('vet_hospital.hospital_name'), nullable=False)
    hospital = db.relationship('VetHospital', backref='doctors')

class Pet(db.Model):
    pet_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    pet_name = db.Column(db.String(10), nullable=False)
    pet_type = db.Column(db.Enum('Dog', 'Cat', 'Bird', 'Rodents'), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    weight = db.Column(db.Integer, nullable=False)
    color = db.Column(db.String(10), nullable=False)
    breed_name = db.Column(db.String(20), db.ForeignKey('pet_breed.breed_name'))
    adopted = db.Column(db.Boolean, nullable=False)
    adopted_by = db.Column(db.String(20), db.ForeignKey('user.username'))
    adoption_date = db.Column(db.Date)
    provided_by_agency = db.Column(db.String(20), db.ForeignKey('animal_agency.agency_name'))
    breed = db.relationship('PetBreed', backref='pets')
    agency = db.relationship('AnimalAgency', backref='provided_pets')
    adopter = db.relationship('User', backref='adopted_pets')

class PetImage(db.Model):
    image_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    image_url = db.Column(db.String(500), nullable=False)
    image_of_pet = db.Column(db.Integer, db.ForeignKey('pet.pet_id'), nullable=False)
    pet = db.relationship('Pet', backref='images')

class UserCommentPets(db.Model):
    pet_id = db.Column(db.Integer, db.ForeignKey('pet.pet_id'), primary_key=True)
    username = db.Column(db.String(20), db.ForeignKey('user.username'), primary_key=True)
    comment_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    comment_text = db.Column(db.String(100))
    comment_date = db.Column(db.DateTime)
    pet = db.relationship('Pet', backref='comments')
    user = db.relationship('User', backref='pet_comments')

class UserPetInteractions(db.Model):
    username = db.Column(db.String(20), db.ForeignKey('user.username'), primary_key=True)
    pet_id = db.Column(db.Integer, db.ForeignKey('pet.pet_id'), primary_key=True)
    interaction_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    interaction_type = db.Column(db.Enum('Play', 'Feed', 'Pet'), nullable=False)
    interaction_date = db.Column(db.Date, nullable=False)
    interaction_start_time = db.Column(db.Time)
    interaction_end_time = db.Column(db.Time)

class PetVisitDoctor(db.Model):
    pet_id = db.Column(db.Integer, db.ForeignKey('pet.pet_id'), primary_key=True)
    doctor_id = db.Column(db.String(10), db.ForeignKey('doctor.doctor_id'), primary_key=True)
    visit_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    visit_date = db.Column(db.Date, nullable=False)
    diagnosis = db.Column(db.String(100), nullable=False)
    medications = db.Column(db.String(50), nullable=False)
    health_level = db.Column(db.Enum('Great', 'Good', 'Moderate', 'Need Care'), nullable=False)
    pet = db.relationship('Pet', backref='doctor_visits')
    doctor = db.relationship('Doctor', backref='pet_visits')
