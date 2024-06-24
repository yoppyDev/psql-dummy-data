-- Table Definitions
DROP TABLE IF EXISTS dept_emp,
    dept_manager,
    titles,
    salaries,
    employees,
    departments;

CREATE TABLE employees (
                           emp_no      SERIAL PRIMARY KEY,
                           birth_date  DATE            NOT NULL,
                           first_name  VARCHAR(14)     NOT NULL,
                           last_name   VARCHAR(16)     NOT NULL,
                           gender      CHAR(1)         NOT NULL CHECK (gender IN ('M', 'F')),
                           hire_date   DATE            NOT NULL
);

CREATE TABLE departments (
                             dept_no     CHAR(4)         PRIMARY KEY,
                             dept_name   VARCHAR(40)     NOT NULL UNIQUE
);

CREATE TABLE dept_manager (
                              emp_no       INT             NOT NULL,
                              dept_no      CHAR(4)         NOT NULL,
                              from_date    DATE            NOT NULL,
                              to_date      DATE            NOT NULL,
                              FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
                              FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
                              PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
                          emp_no      INT             NOT NULL,
                          dept_no     CHAR(4)         NOT NULL,
                          from_date   DATE            NOT NULL,
                          to_date     DATE            NOT NULL,
                          FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
                          FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
                          PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
                        emp_no      INT             NOT NULL,
                        title       VARCHAR(50)     NOT NULL,
                        from_date   DATE            NOT NULL,
                        to_date     DATE,
                        FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
                        PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
                          emp_no      INT             NOT NULL,
                          salary      INT             NOT NULL,
                          from_date   DATE            NOT NULL,
                          to_date     DATE            NOT NULL,
                          FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
                          PRIMARY KEY (emp_no, from_date)
);

-- View Definitions
CREATE OR REPLACE VIEW dept_emp_latest_date AS
SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
FROM dept_emp
GROUP BY emp_no;

-- shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
SELECT l.emp_no, dept_no, l.from_date, l.to_date
FROM dept_emp d
         INNER JOIN dept_emp_latest_date l
                    ON d.emp_no = l.emp_no AND d.from_date = l.from_date AND l.to_date = d.to_date;

-- Data Loading
\i /docker-entrypoint-initdb.d/dummy_data/load_departments.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_employees.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_dept_emp.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_dept_manager.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_titles.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_salaries1.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_salaries2.dump
\i /docker-entrypoint-initdb.d/dummy_data/load_salaries3.dump

