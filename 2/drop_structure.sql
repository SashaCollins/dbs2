-- order fits both possibilities
DROP TABLE AccountTable;  -- not available in possibility 2
DROP TABLE BranchOffice;
DROP TABLE Customer;

DROP TYPE AccountType;
DROP TYPE BranchOfficeType;
DROP TYPE BranchAccountsType;  -- only available in possibility 2
DROP TYPE AccountOwnerType;  -- only available in possibility 1
DROP TYPE CustomerType;
DROP TYPE AccountsT;  -- only available in possibility 2
DROP TYPE AddressType;