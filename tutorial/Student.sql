CREATE TABLE Student {
    id int,
    name varchar(255),
    graduated boolean
}

// CURD
INSERT INTO Student VALUES('000001', 'Fanwei', false)
DELETE FROM Student WHERE id='000001';
UPDATE Student SET name='Jiangnan' WHERE id='000001';
SELECT * FROM Student WHERE id='000001';
