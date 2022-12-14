/****** Script for SelectTopNRows command from SSMS  ******/
  /* Cleaning Data in SQL Queries
  */
    select * from [NashVille Houses] 
  ---------------------------------------------------------------------------------------------------

  -- Standardize Date Format


	ALTER TABLE [NashVille Houses]
	Add SalesDateConverted Date;

	Update [NashVille Houses]
	SET SalesDateConverted = CONVERT(Date,SaleDate);

  -----------------------------------------------------------------------------------

  -- Populate Property Address Data

  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) 
  from [NashVille Houses] a
  join [NashVille Houses] b
  on a.ParcelID =b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ] 
  where a.PropertyAddress is null

  update a 
  SET PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress) 
  from [NashVille Houses] a
  join [NashVille Houses] b
  on a.ParcelID =b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ] 
  where a.PropertyAddress is null
 
  -------------------------------------------------------------------------------------

  -- Breaking out address into Individual Columns (Address ,City,State)
  select PropertyAddress 
  from [NashVille Houses]
   
   SELECT
   SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
   , SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from [NashVille Houses]
   

   ALTER TABLE [NashVille Houses]
	Add PropertySplitAddress NvarChar(255);

	Update [NashVille Houses]
	SET PropertySplitAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

	ALTER TABLE [NashVille Houses]
	Add PropertySplitCity NvarChar(255);
	
	 Update [NashVille Houses]
	SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) 


	select PropertySplitAddress,PropertySplitCity from [NashVille Houses]



	 
--------------------------------------------------------------------------

	 --Splitting Address with parsename method
	 
	 select OwnerAddress from [NashVille Houses]
	 
	 SELECT
	  PARSENAME(Replace(OwnerAddress,',','.'),3),
	    PARSENAME(Replace(OwnerAddress,',','.'),2)
	      ,PARSENAME(Replace(OwnerAddress, ',','.'),1)
	 from [NashVille Houses]

	  ALTER TABLE [NashVille Houses]
	Add OwnerSplitAddress NvarChar(255);
	 
	 Update [NashVille Houses]
	SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)  

	ALTER TABLE [NashVille Houses]
	Add OwnerSplitCity NvarChar(255);
	 
	 Update [NashVille Houses]
	SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)  

	ALTER TABLE [NashVille Houses]
	Add OwnerSplitState NvarChar(255);
	 
	 Update [NashVille Houses]
	SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

	select * from [NashVille Houses]

	------------------------------------------------------------------------------
	-- Change Y and N to Yes and No
	select Distinct(SoldAsVacant),Count(SoldAsVacant)
	From [NashVille Houses]
	Group by SoldAsVacant
	order by 2

	Select SoldAsVacant,
	Case when SoldAsVacant = 'Y' tHEN 'Yes'
	     when SoldAsVacant = 'N' tHEN 'No'
		 Else SoldAsVacant 
		 End
	from [NashVille Houses]

	Update [NashVille Houses]
	SET SoldAsVacant = Case when SoldAsVacant = 'Y' tHEN 'Yes'
	     when SoldAsVacant = 'N' tHEN 'No'
		 Else SoldAsVacant 
		 End

		 --------------------------------------------------------------------------------

		 --Remove Duplicates
		 With RowNumCTE AS (
		 Select * ,
		 Row_Number() over (
		  Partition BY ParcelID,
		               PropertyAddress,
					   SalePrice,
					   SaleDate,
					   LegalReference
					   Order by
					    UniqueID
						) row_num

		  from [NashVille Houses]
		 -- order by ParcelID
		 )
		  DELETE
		  from RowNumCTE 
		  where row_num > 1
		 -- order by PropertyAddress






		 ----------------------------------------------------------------------------------------

		 --- Remove Unused Columns
		 Select * 
		 from [NashVille Houses]

		 ALTER TABLE [NashVille Houses]
		 Drop Column OwnerAddress ,TaxDistrict,PropertyAddress

		 ALTER TABLE [NashVille Houses]
		 Drop Column SaleDate
		 