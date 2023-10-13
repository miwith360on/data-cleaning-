--Cleaning Data in SQL Queries
select*
from portfolioproject..nashvillehousing
-------------------------------------------------------------
-- Standardize Date Format
select SaleDateconverted, convert ( date,saledate)
from portfolioproject..nashvillehousing

update nashvillehousing
 set SaleDate =  convert ( date,saledate)
 
 alter table nashvillehousing 
 add saledateconverted date;

 update nashvillehousing
 set SaleDateconverted =  convert ( date,saledate)
-------------------------------------------------------------------------------------------------------
 -- Populate Property Address data
 select*
from portfolioproject..nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL (  a.PropertyAddress,b.PropertyAddress)
from portfolioproject..nashvillehousing a
join portfolioproject..nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress =  ISNULL (  a.PropertyAddress,b.PropertyAddress)
 from portfolioproject..nashvillehousing a
join portfolioproject..nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
from portfolioproject..nashvillehousing
--where PropertyAddress is null
order by ParcelID
select
SUBSTRING ( propertyaddress, 1, CHARINDEX ( ',', PropertyAddress)-1) as adderss
,SUBSTRING ( propertyaddress, CHARINDEX ( ',', PropertyAddress)+1,  len (PropertyAddress)) as adderss

from portfolioproject..nashvillehousing

alter table nashvillehousing 
 add propertysplitaddress nvarchar (255);
 
 update nashvillehousing
 set propertysplitaddress  = SUBSTRING ( propertyaddress, 1, CHARINDEX ( ',', PropertyAddress)-1) 
 
 alter table nashvillehousing 
 add propertysplitcity nvarchar (255);
 update nashvillehousing
 set propertysplitcity  = SUBSTRING ( propertyaddress, CHARINDEX ( ',', PropertyAddress)+1,  len (PropertyAddress))

 select*
 from portfolioproject..nashvillehousing
 --------------------------------------------------------

 -- Change Y and N to Yes and No in "Sold as Vacant" field


 select owneraddress
 from portfolioproject..nashvillehousing
 
 select
 PARSENAME ( replace(owneraddress, ',', '.'), 3)
  ,PARSENAME ( replace(owneraddress, ',', '.'), 2)
  , ,PARSENAME ( replace(owneraddress, ',', '.'), 1)
   from portfolioproject..nashvillehousing


   alter table nashvillehousing 
 add ownersplitaddress nvarchar (255);
 
 update nashvillehousing
 set  ownersplitaddress  = PARSENAME ( replace(owneraddress, ',', '.'), 3)
 
 alter table nashvillehousing 
 add  ownersplitcity nvarchar (255);
 
 update nashvillehousing
 
 set ownersplitcity  = PARSENAME ( replace(owneraddress, ',', '.'), 2)
 
 alter table nashvillehousing 
 add ownersplitstate nvarchar (255);
 
 update nashvillehousing
 set  ownersplitstate  =PARSENAME ( replace(owneraddress, ',', '.'), 1)

 select*
 from portfolioproject..nashvillehousing
 --------------------------------------------------
 -- Delete Unused Columns

 select distinct (soldasvacant), COUNT(SoldAsVacant)
 from portfolioproject..nashvillehousing
 group by SoldAsVacant
 order by 2

 select soldasvacant 
 , case when soldasvacant = 'y' then 'yes' 
    when soldasvacant = 'n' then 'no'
	 else soldasvacant 
	 end
	 from portfolioproject..nashvillehousing
	 
	 update nashvillehousing

	 set soldasvacant = case when soldasvacant = 'y' then 'yes' 
    when soldasvacant = 'n' then 'no'
	 else soldasvacant 
	 end
	 from portfolioproject..nashvillehousing

	WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From portfolioproject..nashvillehousing
--order by ParcelID
)
select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
   
   -- Delete Unused Columns
   select*
   from portfolioproject..nashvillehousing
  
  alter table  portfolioproject..nashvillehousing
  drop column owneraddress, taxdistrict, propertyaddress
  
alter table    portfolioproject..nashvillehousing
  drop column saledate 
  
