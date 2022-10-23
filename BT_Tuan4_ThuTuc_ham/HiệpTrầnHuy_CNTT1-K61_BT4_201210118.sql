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

SELECT * FROM dbo.ChiTietVanTai
go

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
	SELECT SoXe, SoLuongVT
	FROM dbo.TrongTai JOIN dbo.ChiTietVanTai ON ChiTietVanTai.MaTrongTai = TrongTai.MaTrongTai
	WHERE SoLuongVT >= @trongTai
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
	WHERE SoLuongVT >= @trongTai AND @maLoTrinh = MaLoTrinh
	GROUP BY MaVT) AS a), 0)
END

SELECT dbo.cau4(8, 'HN') AS TongSoLuong
GO
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
		WHERE @namVanTai = YEAR(NgayDen) AND @namVanTai = YEAR(NgayDi) 
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
CREATE PROCEDURE cau7 @soXe NVARCHAR(20), @namVanTai INT, @tien MONEY OUTPUT, @nam INT OUTPUT AS
BEGIN
	SET @nam = @namVanTai
	SET @tien = ISNULL((SELECT SUM(DonGia) 
			FROM dbo.ChiTietVanTai JOIN dbo.LoTrinh ON LoTrinh.MaLoTrinh = ChiTietVanTai.MaLoTrinh
			WHERE @namVanTai = YEAR(NgayDi) AND @namVanTai = YEAR(NgayDen) 
				AND @soXe = SoXe), 0)
END
GO 

DROP PROCEDURE cau7

SELECT * FROM dbo.ChiTietVanTai

DECLARE @tien MONEY,
        @nam INT;
EXEC dbo.cau7 @soXe = N'333',          -- nvarchar(20)
              @namVanTai = 2014,       -- int
              @tien = @tien OUTPUT, -- money
              @nam = @nam OUTPUT    -- int
PRINT @tien
PRINT @nam
GO
--8. Tạo thủ tục có đầu vào là mã trọng tải, đầu ra là số lượng xe vượt quá trọng tải quy định 
--của mã trọng tải đó.
CREATE PROCEDURE cau8 @maTrongTai NVARCHAR(20), @soLuong INT OUTPUT AS 
BEGIN
	SET @soLuong = ISNULL((SELECT COUNT(MaVT) FROM dbo.ChiTietVanTai WHERE @soLuong > SoLuongVT), 0)
END

DECLARE @soLuong INT;
EXEC dbo.cau8 @maTrongTai = N'333',         -- nvarchar(20)
              @soLuong = @soLuong OUTPUT -- int
PRINT @soLuong

--Bài tập 2:
--1. Tạo hàm với đầu vào là năm, đầu ra là danh sách nhân viên sinh vào năm đó

--2. Tạo hàm với đầu vào là số thâm niên (số năm làm việc) đầu ra là danh sách nhân viên có
--thâm niên đó

--3. Tạo hàm đầu vào là chức vụ đầu ra là những nhân viên cùng chức vụ đó

--4. Tạo hàm đưa ra thông tin về nhân viên được tăng lương của ngày hôm nay (giả sử 3 năm
--lên lương 1 lần)

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

--6. Tạo thủ tục có đầu vào là mã phòng, đầu ra là số nhân viên của phòng đó và tên trưởng
--phòng

--7. Tạo thủ tục có đầu vào là mã phòng, tháng, năm, đầu ra là số tiền lương của phòng đó