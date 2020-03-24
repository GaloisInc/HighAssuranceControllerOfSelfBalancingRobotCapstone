CREATE TABLE OtisData (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  PITCH FLOAT(32, 3) NOT NULL,
  YAW FLOAT(32, 3) NOT NULL,
  OUTPUT1 FLOAT(32, 3) NOT NULL,
  OUTPUT2 FLOAT(32, 3) NOT NULL,
  reading_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);