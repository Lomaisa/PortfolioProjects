/*Selecting Columns from the Data*/

Select*
From NashvilleHousing

/*Converting SaleDate Column to Datetime  */

ALTER TABLE NashvilleHousing
	ALTER COLUMN SaleDate date;
GO
/* Populate Property Address Data */

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelId = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

/* Update the Data */
update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)

from NashvilleHousing a
join NashvilleHousing b
on a.ParcelId = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

/* Splitting The PropertyAddress Column into the Address and Column */

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress,1, Charindex(',',PropertyAddress)-1) 



Alter Table NashvilleHousing
Add PropertySplitCity NVarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, Len(PropertyAddress))



/* Splitting The OwnerAddress Column into the Address and Column */

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar (255);

Update NashvilleHousing
Set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',', '.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar (255);

Update NashvilleHousing
Set OwnerSplitCity = Parsename(Replace(OwnerAddress,',', '.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar (255);

Update NashvilleHousing
Set OwnerSplitState = Parsename(Replace(OwnerAddress,',', '.'),1)


/* Cleaning the SoldAsVacant Column*/

Select Distinct SoldAsVacant, Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case When SoldAsVacant='Y' then 'YES'
	 When SoldAsVacant = 'N' then 'NO'
	 Else SoldAsVacant
	 End
From NashvilleHousing


Update NashvilleHousing

Set SoldAsVacant = Case When SoldAsVacant='Y' then 'YES'
	 When SoldAsVacant = 'N' then 'NO'
	 Else SoldAsVacant
	 End
From NashvilleHousing

/*Deleting Unwanted Columns*/

Alter Table NashvilleHousing
Drop column PropertyAddress, OwnerAddress, TaxDistrict