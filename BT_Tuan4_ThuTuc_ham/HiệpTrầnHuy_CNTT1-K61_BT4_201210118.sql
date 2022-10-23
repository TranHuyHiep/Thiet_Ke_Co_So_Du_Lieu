-- Bài tập 1: 
--1. Tạo hàm có đầu vào là lộ trình, đầu ra là số xe, mã trọng tải, số lượng vận tải, ngày đi, ngày 
--đến (SoXe, MaTrongTai, SoLuongVT, NgayDi, NgayDen
CREATE FUNCTION cau1(@maLoTrinh NVARCHAR(20)) RETURNS TABLE AS
RETURN (
	SELECT SoXe, MaTrongTai, SoLuongVT, NgayDi, NgayDen
	FROM dbo.ChiTietVanTai
	WHERE @maLoTrinh = MaLoTrinh
)
GO

SELECT * FROM cau1(N'HN')
go
--2. Thiết lập hàm có đầu vào là số xe, đầu ra là thông tin về lộ trình
CREATE FUNCTION cau2(@soXe NVARCHAR(20)) RETURNS TABLE
RETURN (
	SELECT ChiTietVanTai.MaLoTrinh, TenLoTrinh, DonGia, ThoiGianQD
	FROM dbo.ChiTietVanTai JOIN dbo.LoTrinh ON LoTrinh.MaLoTrinh = ChiTietVanTai.MaLoTrinh
	WHERE @soXe = SoXe
)
GO

SELECT * FROM cau2('333')
GO
--3.Tạo hàm có đầu vào là trọng tải, đầu ra là các số xe có trọng tải quy định lớn hơn hoặc bằng 
--trọng tải đó
CREATE FUNCTION cau3(@trongTai INT) RETURNS TABLE
RETURN (
	SELECT DISTINCT SoXe
	FROM dbo.TrongTai JOIN dbo.ChiTietVanTai ON ChiTietVanTai.MaTrongTai = TrongTai.MaTrongTai
	WHERE TrongTaiQD >= @trongTai
)
GO

SELECT * FROM dbo.cau3(8)
GO
--4. Tạo hàm có đầu vào là trọng tải và mã lộ trình, đầu ra là số lượng xe có trọng tải quy định 
--lớn hơn hoặc bằng trọng tải đó và thuộc lộ trình đó.
CREATE FUNCTION cau4(@trongTai INT, @maLoTrinh NVARCHAR(20)) RETURNS INT AS 
BEGIN
	RETURN ISNULL((SELECT count(a.SoLuong) AS TongSoLuong FROM (SELECT SUM(MaVT) AS SoLuong
	FROM dbo.TrongTai JOIN dbo.ChiTietVanTai ON ChiTietVanTai.MaTrongTai = TrongTai.MaTrongTai
	WHERE TrongTaiQD >= @trongTai AND @maLoTrinh = MaLoTrinh
	GROUP BY MaVT) AS a), 0)
END

SELECT dbo.cau4(8, 'HN') AS TongSoLuong
GO

DROP FUNCTION dbo.cau4 
--5. Tạo thủ tục có đầu vào Mã lộ trình đầu ra là số lượng xe thuộc lộ trình đó.
CREATE PROCEDURE cau5 @maLoTrinh NVARCHAR(20), @soLuong INT OUT AS
BEGIN
	SET @soluong = ISNULL(
	(SELECT count(MaVT) AS SoLuongXe
	FROM dbo.ChiTietVanTai
	WHERE @maLoTrinh = MaLoTrinh), 0)
END
GO

DECLARE @soLuong INT
EXEC dbo.cau5 'HN', @soLuong OUTPUT
PRINT @soLuong
GO 
--6. Tạo thủ tục có đầu vào là mã lộ trình, năm vận tải, đầu ra là số tiền theo mã lộ trình và năm 
--vận tải đó
CREATE PROCEDURE cau6 @maLoTrinh NVARCHAR(20), @namVanTai INT, @tien MONEY OUTPUT AS
BEGIN
	SET @tien = ISNULL((
		SELECT SUM(DonGia)
		FROM dbo.ChiTietVanTai JOIN dbo.LoTrinh ON LoTrinh.MaLoTrinh = ChiTietVanTai.MaLoTrinh
		WHERE @namVanTai = YEAR(NgayDen) AND @namVanTai = YEAR(NgayDen) 
			AND ChiTietVanTai.MaLoTrinh = @maLoTrinh
		), 0)
END
GO

DECLARE @tien MONEY;
EXEC dbo.cau6 @maLoTrinh = N'HN',    -- nvarchar(20)
              @namVanTai =2014,      -- int
              @tien = @tien OUTPUT -- money
PRINT @tien
GO

--7. Tạo thủ tục có đầu vào là số xe, năm vận tải, đầu ra là số tiền theo số xe và năm vận tải đó
CREATE PROCEDURE CAU7 @SoXe nvarchar(255), @NamVanTai int, @SoTien Money OUTPUT
AS
BEGIN
	SELECT @SoTien = SUM(SoLuongVT * DonGia)
	FROM LoTrinh JOIN ChiTietVanTai
	ON LoTrinh.MaLoTrinh = ChiTietVanTai.MaLoTrinh
	WHERE @SoXe = SoXe AND YEAR(NgayDi) = @NamVanTai
END
GO 

DECLARE @SoTien Money
EXEC CAU7 '333', 2014, @SoTien OUTPUT
PRINT @SoTien
GO

--8. Tạo thủ tục có đầu vào là mã trọng tải, đầu ra là số lượng xe vượt quá trọng tải quy định 
--của mã trọng tải đó.
CREATE PROCEDURE cau8 @maTrongTai NVARCHAR(20), @soLuong INT OUTPUT AS 
BEGIN
	DECLARE @TrongTaiQD INT
	SELECT @TrongTaiQD = TrongTaiQD
	FROM dbo.TrongTai
	WHERE @maTrongTai = @maTrongTai
	SET @soLuong = (SELECT COUNT(DISTINCT SoXe) FROM dbo.ChiTietVanTai JOIN dbo.TrongTai ON TrongTai.MaTrongTai = ChiTietVanTai.MaTrongTai
	WHERE TrongTaiQD >= @TrongTaiQD)
END
GO

DECLARE @soLuong INT
EXEC dbo.cau8 '52',         -- nvarchar(20)
              @soLuong OUTPUT -- int
PRINT @soLuong

--Bài tập 2:
--1. Tạo hàm với đầu vào là năm, đầu ra là danh sách nhân viên sinh vào năm đó
CREATE FUNCTION Cau1(@year INT) RETURNS TABLE AS 
RETURN 
(
	SELECT *
	FROM dbo.tNhanVien
	WHERE YEAR(NTNS) = @year
)
GO

SELECT * FROM cau1(1962) 
GO
--2. Tạo hàm với đầu vào là số thâm niên (số năm làm việc) đầu ra là danh sách nhân viên có
--thâm niên đó
CREATE FUNCTION cau2(@year INT) RETURNS TABLE AS
RETURN
(
	SELECT *
	FROM dbo.tNhanVien
	WHERE @year = YEAR(GETDATE()) - YEAR(NgayBD)
)
GO

SELECT * FROM cau2(25)
GO
--3. Tạo hàm đầu vào là chức vụ đầu ra là những nhân viên cùng chức vụ đó
CREATE FUNCTION cau3(@chucvu NVARCHAR(10)) RETURNS TABLE AS
RETURN
(
	SELECT tChiTietNhanVien.MaNV, HO, TEN, PHAI, NTNS, ChucVu
	FROM dbo.tChiTietNhanVien JOIN dbo.tNhanVien ON tNhanVien.MaNV = tChiTietNhanVien.MaNV
	WHERE ChucVu = @chucvu
)
GO

SELECT * FROM cau3('TL')
GO

--4. Tạo hàm đưa ra thông tin về nhân viên được tăng lương của ngày hôm nay (giả sử 3 năm
--lên lương 1 lần)
CREATE FUNCTION cau4() RETURNS TABLE AS
RETURN
(
	SELECT *
	FROM dbo.tNhanVien
	WHERE (YEAR(GETDATE()) - YEAR(NgayBD)) % 3 = 0
		AND MONTH(NgayBD) = MONTH(GETDATE())
		AND DAY(NgayBD) = DAY(GETDATE())
)
GO

SELECT * FROM dbo.cau4()
GO

--5. Tạo Hàm xây dựng bảng lương của nhân viên gồm các thông tin sau:
--- Lương = lương cơ bản * HSLuong + Phụ cấp (Giả sử lương cơ bản=1490000vnd (1.49tr))
--- BHXH: 8%*lương (bảo hiểm xã hội)
--- BHYT: 1,5% * lương (bảo hiểm y tế)
--- BHTN: 1%* lương (Bảo hiểm thất nghiệp)
--- Thuế TNCN (Thuế thu nhập cá nhân) được tính như sau:
--Trong đó: TN= Lương - BHXH - BHYT - BHTN - 11tr (mức chịu thuế) - GTGC*4.4tr (Giảm
--trừ gia cảnh)
--- Phụ cấp: Mức độ công việc là A thì phụ cấp 10tr, mức độ B là 8tr, mức độ C là 5tr
--- Thực lĩnh: Lương – (BHXH+BHYT+BHTN + Thuế TNCN)

ALTER TABLE dbo.tChiTietNhanVien
ADD GTGC FLOAT(2)

CREATE FUNCTION cau5() RETURNS TABLE AS 
RETURN 
(
	select Luong, BHXH, BHYT, BHTN, ThueTN, Luong-BHXH- BHYT-BHTN-ThueTN as ThucNhan
	FROM (	
		select n.MaNV, TEN, 
			HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000)) as Luong, 
			(HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000)))*0.08 as BHXH,
			(HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000)))*0.015 as BHYT,
			(HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000)))*0.01 as BHTN,
			iif(HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000>0, HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000,0) as ThuNhap,
			(case 
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000-isnull(isnull(GTGC,0),0)*4400000 <=0 then 0
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=5000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.05
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=10000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.10-250000
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=18000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.15-750000
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=32000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.20-1650000
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=52000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.25-3250000
				when HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000 <=80000000 then (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.30-5850000
				else (HSLuong*1490000 + iif(MucDOCV like 'A%', 10000000, iif(MucDOCV like 'B%', 8000000, 5000000))-11000000-isnull(GTGC,0)*4400000)*0.35-9850000		
			end) as ThueTN
		FROM tNhanVien n join tChiTietNhanVien c on n.MaNV=c.MaNV) as temp
)
GO

SELECT * FROM cau5()
GO

--6. Tạo thủ tục có đầu vào là mã phòng, đầu ra là số nhân viên của phòng đó và tên trưởng
--phòng
CREATE PROCEDURE cau6 @maphong varchar(10), @soluong INT OUTPUT, @tenTruongPhong NVARCHAR(20) OUTPUT
AS
BEGIN
	SELECT @soluong = COUNT(MaNV)
	FROM dbo.tNhanVien
	where @maphong = MaPB
	SELECT @tenTruongPhong = HO + ' ' + TEN
	FROM dbo.tNhanVien JOIN dbo.tChiTietNhanVien ON tChiTietNhanVien.MaNV = tNhanVien.MaNV
	WHERE @maphong = MaPB AND ChucVu = 'TP'
END

DECLARE @soluong INT, @tenTruongPhong NVARCHAR(20)
EXEC cau6 'KH', @soluong OUTPUT, @tenTruongPhong OUTPUT
PRINT @soluong
PRINT @tenTruongPhong
GO

--7. Tạo thủ tục có đầu vào là mã phòng đầu ra là số tiền lương của phòng đó
CREATE PROCEDURE cau7 @MaPhong NVARCHAR(10), @SoTienLuong MONEY OUTPUT
AS
BEGIN 
	SELECT @SoTienLuong = SUM(
		1490000 * HSLuong + iif(MucDoCV LIKE 'A%', 10000000, (iif(MucDoCV LIKE 'B%', 8000000, 5000000)))
	)
	FROM dbo.tChiTietNhanVien JOIN dbo.tNhanVien ON tNhanVien.MaNV = tChiTietNhanVien.MaNV
	WHERE @MaPhong = MaPB
END
GO

DECLARE @SoTienLuong MONEY
EXEC dbo.cau7  @MaPhong = N'KH',                     -- nvarchar(10)
              @SoTienLuong = @SoTienLuong OUTPUT -- money
PRINT @SoTienLuong
GO
