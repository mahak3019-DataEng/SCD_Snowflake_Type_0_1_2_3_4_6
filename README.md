- # Slowly Changing dimensions(SCD 0,1,2,3,4,6)
    
    It is the concept in data warehousing that how the historical data is managed and maintained over time.
    
    Since dimensional data doesn’t get change that frequently that’s why we call them slowly changing dimensions.
    
    Example: if a customer changes their address, you need to decide how to store the new address and whether to keep a history of previous addresses.
    
    1. Type 0: They retain the original. It is assumed that dimension do not get change.
    2. Type 1: Overwrite
        
        In SCD type 1 values are overwritten and no history is maintained. So once the data is updated, there is no way to find out what the previous value was.
        
        ### **Type 1 Example**
        
        Consider a `Customer` table where the address of a customer is updated. The table would be:
        
        ```
        CustomerID | Address
        ---------------------
        1          | 456 New St
        ```
        
        When the address changes, you overwrite the old address:
        
        ```
        CustomerID | Address
        ---------------------
        1          | 789 Another St
        ```
        
    3. Type 2: Add the New Row
        
        In the SCD Type 2, we maintain a complete history of changes. Everytime there is a change, we add the new row with all the details without deleting the previous values. There are multiple way we can do this:
        
        1. Using a flag
            
            We use a flag to indicate if a particular value is active or not.
            
            ### **Type 2 Example**
            
            For historical tracking, you store each version of the address:
            
            ```
            CustomerID | Address       | isActive
            ---------------------------------------
            1          | 123 Old St    | False 
            1          | 456 New St    | True
            ```
            
            Note: In this the surrogate key concept comes into the picture. When we add the new row we can notice the “CustomerID” is not primary key any more. So that’s why we add the surrogate key to uniquely identify the row.
            
        2. Using the Version Number
            
            In this we use the version numbers to keep track of changes. The row with highest version is the most current value. Use MAX(Version) to query the row.
            
        3. Using date ranges
            
            In this we use the date ranges to show the period a particular record was active.
            
            Example: 
            
            For historical tracking, you store each version of the address:
            
            ```
            plaintextCopy code
            CustomerID | Address       | StartDate  | EndDate
            ---------------------------------------------------
            1          | 123 Old St    | 2023-01-01 | 2023-06-30
            1          | 456 New St    | 2023-07-01 | NULL
            ```
            
            Also sometime we combine the date ranges and isActive column.
            
    4. Type 3: Add the New Column
        
        In SCD3, we maintain onaly a partial history and not a complete history. Instead of adding additional rows, we add an extra column that stores the previous value, so only one version of previous version of historic data will be preserved. 
        
        In this we don’t need to maintain the surrogate keys as there will be only one row.
        
        **Example**:
        
        ```
        Customer Table:
        CustomerID | CurrentAddress | PreviousAddress
        ---------------------------------------------
        1          | 456 New St     | 123 Old St
        ```
        
    5. Type 4: Historical Table
        
        It is applied when one of the dimensions that change realtively frequently. In this we change the fast changing attribute of the dimension table into another dimension table so that we don’t need to update the main table with large data again and again.
        Current data is only in the main table and rest of the historical data is in another table.
        
        **Current Address Table**:
        
        ```
        CustomerID | CurrentAddress
        ---------------------------
        1          | 456 New St
        ```
        
        **Address History Table**:
        
        ```
        CustomerID | Address       | StartDate  | EndDate
        ---------------------------------------------------
        1          | 123 Old St    | 2023-01-01 | 2023-06-30
        1          | 456 New St    | 2023-07-01 | NULL
        ```
        
    6. Type 6: Hybrid
        
        It is the combination of SCD1,2,3. In this type, along with the addition of the new rows, we also update the latest value in all the rows.