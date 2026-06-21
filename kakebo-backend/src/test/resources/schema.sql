CREATE TABLE IF NOT EXISTS T_INCOMES
(
	ID          integer,
	AMOUNT      numeric,
	INCOME_NAME varchar(256),
	INCOME_DATE timestamp
);

CREATE TABLE IF NOT EXISTS T_EXPENSES
(
	ID           integer,
	AMOUNT       numeric,
	EXPENSE_NAME varchar(256),
	EXPENSE_DATE timestamp
);