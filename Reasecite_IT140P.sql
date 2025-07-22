DROP TABLE ENROLLMENT; 
DROP TABLE QUESTION;
DROP TABLE SCORE;
DROP TABLE sectioN;
DROP TABLE STUDENT;
DROP TABLE SUBJECT;

-----------------------

INSERT INTO subject (subj_id, subj_name) VALUES 
('IT190-3P', 'Sub1'),
('IT190-2P', 'Sub2'),
('CS198L', 'Sub3'),
('IT145', 'Sub4');

---CHECK CONSTRAINTS
INSERT INTO subject (subj_id, subj_name) VALUES ('IT145', 'Sub4');
---

INSERT INTO section (sect_id, subj_id) VALUES 
('CIS341', 'IT190-3P'),
('CIS342','IT190-2P'),
('CIS301', 'CS198L'),
('CIS343', 'CS198L');

---CHECK CONSTRAINTS
INSERT INTO section (sect_id, subj_id) VALUES 
('CIS343', 'notasubject');
---

INSERT INTO student (stud_id, stud_name) VALUES 
('2022153105', 'Student One'),  
('2022154134', 'Student Two');  

---CHECK CONSTRAINTS
INSERT INTO student (stud_id, stud_name) VALUES 
('2022154134', 'Student Two');  
---

INSERT INTO question (ques_name, subj_id) VALUES 
('Define the OSI model.', 'IT190-3P'),
('Explain GET vs POST methods.', 'IT190-2P'),
('What is a binary tree?', 'CS198L'),
('Describe SDLC phases.', 'IT145');

---CHECK CONSTRAINTS
INSERT INTO question (ques_name, subj_id) VALUES 
('Describe SDLC phases.', 'notasubject');
INSERT INTO question (ques_name, subj_id) VALUES 
('Describe SDLC phases.', 'IT145');
---

INSERT INTO score (stud_id, subj_id, score, date) VALUES 
(2022153105, 'IT190-3P', 85, NOW()),
(2022153105, 'IT190-2P', 92, NOW()),
(2022153105, 'CS198L', 88, NOW()),
(2022153105, 'IT145', 90, NOW()),
(2022154134, 'IT190-3P', 78, NOW()),
(2022154134, 'IT190-2P', 81, NOW()),
(2022154134, 'CS198L', 84, NOW()),
(2022154134, 'IT145', 87, NOW());

---CHECK CONSTRAINTS
INSERT INTO score (stud_id, subj_id, score, date) VALUES 
(2022154134, 'IT145', 87, NOW());
INSERT INTO score (stud_id, subj_id, score, date) VALUES 
(000000, 'IT145', 87, NOW());
INSERT INTO score (stud_id, subj_id, score, date) VALUES 
(2022154134, 'notsubj', 87, NOW());
---

-- Student 1 enrollments
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
(2022153105, 'CIS342', 'IT190-2P'),
(2022153105, 'CIS301', 'CS198L'),
(2022153105, 'CIS343', 'IT145');

---CHECK CONSTRAINTS
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
('2022153105', 'notasection', 'IT190-3P');
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
('00000', 'CIS341', 'IT190-3P');
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
('2022153105', 'CIS341', 'notsubject');
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
(2022153105, 'CIS343', 'IT145');
---

-- Student 2 enrollments
INSERT INTO enrollment (stud_id, sect_id, subj_id) VALUES 
(2022154134, 'CIS341', 'IT190-3P'),
(2022154134, 'CIS342', 'IT190-2P'),
(2022154134, 'CIS301', 'CS198L'),
(2022154134, 'CIS343', 'IT145');


------------------------

CREATE TABLE subject (
  subj_id VARCHAR(8) PRIMARY KEY,
  subj_name VARCHAR(255) NOT NULL
);

CREATE TABLE section (
  sect_id VARCHAR(8) NOT NULL,
  subj_id VARCHAR(8) NOT NULL,
  PRIMARY KEY (sect_id, subj_id),
  CONSTRAINT fk_sSubject FOREIGN KEY (subj_id) REFERENCES subject(subj_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE student (
  stud_id INT PRIMARY KEY,
  stud_name VARCHAR(255) NOT NULL
);

CREATE TABLE question (
  ques_id INT AUTO_INCREMENT PRIMARY KEY,
  ques_name VARCHAR(255) NOT NULL,
  subj_id VARCHAR(8) NOT NULL,
  CONSTRAINT fk_qSubject FOREIGN KEY (subj_id)
    REFERENCES subject(subj_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uc_quesName_subject UNIQUE (ques_name, subj_id)
);

CREATE TABLE score (
  stud_id INT NOT NULL,
  subj_id VARCHAR(8) NOT NULL,
  score INT DEFAULT 0,
  date TIMESTAMP,
  PRIMARY KEY (stud_id, subj_id),
  CONSTRAINT fk_scoreStudent FOREIGN KEY (stud_id)
    REFERENCES student(stud_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_scoreSubject FOREIGN KEY (subj_id)
    REFERENCES subject(subj_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE enrollment (
  enroll_id INT AUTO_INCREMENT PRIMARY KEY,
  stud_id INT NOT NULL,
  sect_id VARCHAR(8) NOT NULL,
  subj_id VARCHAR(8) NOT NULL,
  CONSTRAINT fk_enrollment_student FOREIGN KEY (stud_id)
    REFERENCES student(stud_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enrollment_section FOREIGN KEY (sect_id)
    REFERENCES section(sect_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enrollment_subject FOREIGN KEY (subj_id)
    REFERENCES subject(subj_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uc_student_section_subject UNIQUE (stud_id, sect_id, subj_id)
);

----------

DELIMITER $$

CREATE PROCEDURE get_subjects()
BEGIN
  SELECT * FROM subject
  ORDER BY subj_id;
END$$

DELIMITER ;

----

DELIMITER $$

CREATE PROCEDURE insert_subject(
  IN p_id VARCHAR(8),
  IN p_name VARCHAR(255)
)
BEGIN
  -- Check for duplicate ID
  IF EXISTS (SELECT 1 FROM subject WHERE subj_id = p_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Duplicate subj_id';
  ELSE
    INSERT INTO subject (subj_id, subj_name)
    VALUES (p_id, p_name);
  END IF;
END$$

DELIMITER ;

----

DELIMITER $$

CREATE PROCEDURE update_subject(
  IN p_id VARCHAR(8),
  IN p_name VARCHAR(255)
)
BEGIN
  DECLARE current_name VARCHAR(255);

  -- Check if subject exists
  SELECT subj_name INTO current_name
  FROM subject
  WHERE subj_id = p_subj_id;

  IF current_name IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Subject ID not found. Cannot update.';
  
  ELSEIF current_name = p_new_name THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Nothing to update. Subject name is already the same.';

  ELSE
    UPDATE subject
    SET subj_name = p_new_name
    WHERE subj_id = p_subj_id;
  END IF;
END$$

DELIMITER ;

-----------

DELIMITER $$

CREATE PROCEDURE delete_subject(
  IN p_id VARCHAR(8)
)
BEGIN
  -- Check if the subject exists
  IF NOT EXISTS (SELECT 1 FROM subject WHERE subj_id = p_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Subject ID does not exist';
  ELSE
    DELETE FROM subject WHERE subj_id = p_id;
  END IF;
END$$

DELIMITER ;


-----------

CREATE INDEX idx_section_subj_id ON section(subj_id);
CREATE INDEX idx_question_subj_id ON question(subj_id);
CREATE INDEX idx_score_subj_id_date ON score(subj_id, date);
CREATE INDEX idx_enroll_subj_sect ON enrollment(subj_id, sect_id);
CREATE INDEX idx_enroll_stud_id ON enrollment(stud_id);