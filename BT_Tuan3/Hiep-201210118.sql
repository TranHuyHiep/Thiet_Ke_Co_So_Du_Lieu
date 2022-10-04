----------------------------BÀI 1----------------------------------

-- Câu 1: Tạo View danh sách sinh viên, gồm các thông tin sau:
--Mã sinh viên, Họ sinh viên, Tên sinh viên, Học bổng
use [BT_Tuan3]

create view Cau1 as
select MaSV, HoSV, TenSV, HocBong
from DSSinhVien 
go
select * FROM Cau1
go
-- Câu 2: Tạo view Liệt kê các sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội, gồm
-- các thông tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
create view Cau2 as
select HoSV, TenSV, MaSV, NoiSinh, HocBong
from DSSinhVien
where HocBong >= 150000 and NoiSinh = N'Hà Nội'
go
select * FROM Cau2
GO
-- Câu 3: Tạo view liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông
-- tin: Mã sinh viên, Họ tên sinh viên, tên khoa, Phái
create view Cau3 as
select MaSV, HoSV, TenSV, TenKhoa, Phai
from DSSinhVien join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
where (TenKhoa = N'Tin Học' or TenKhoa = N'Anh Văn') and Phai = N'Nam'
GO
SELECT * FROM Cau3
GO
-- Câu 4: Tạo view gồm những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên,
-- Tuổi, Tên khoa.
CREATE VIEW Cau4 AS 
SELECT HoSV, TenSV, CONVERT(INT, DATEDIFF(DD, NgaySinh, GETDATE())/365.25) AS tuoi, TenKhoa
FROM DSSinhVien JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
WHERE DATEDIFF(DD, NgaySinh, GETDATE())/365.25 >= 20 
	AND DATEDIFF(DD, NgaySinh, GETDATE())/365.25 <= 25
go
SELECT * FROM Cau4
go
-- Câu 5: Tạo view cho biết thông tin về mức học bổng của các sinh viên, gồm: 
-- Mã sinh viên, Phái, Mã khoa, Mức học bổng. 
-- Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao”
-- nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”
CREATE VIEW Cau5 AS
SELECT MaSV, Phai, MaKhoa, 
(
	CASE 
	WHEN HocBong > 500000 THEN N'Học bổng cao'
	ELSE N'Mức trung bình'
	END
) AS MucHocBong
FROM DSSinhVien
WHERE HocBong > 0
go
SELECT * FROM Cau5
go
-- Câu 6: Tạo view đưa ra thông tin những sinh viên có học bổng lớn hơn bất kỳ học bổng của
-- sinh viên học khóa anh văn
CREATE VIEW Cau6 AS
SELECT MaSV, HoSV, TenSV, HocBong
FROM DSSinhVien INNER JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
WHERE hocbong > (SELECT TOP (1) HocBong
					FROM DSSinhVien JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
					WHERE TenKhoa = N'Anh Văn' 
					ORDER BY HocBong DESC)
GO
SELECT * FROM Cau6
go
-- Câu 7: Tạo view đưa ra thôngz tin những sinh viên đạt điểm cao nhất trong từng môn.
CREATE VIEW Cau7
as
SELECT DSSinhVien.MaSV, HoSV, TenSV, Diem, DMMonHoc.MaMH, TenMH
FROM dbo.DSSinhVien INNER JOIN dbo.KetQua ON KetQua.MaSV = DSSinhVien.MaSV
	INNER JOIN dbo.DMMonHoc ON DMMonHoc.MaMH = KetQua.MaMH, 
	(SELECT DMMonHoc.MaMH, MAX(Diem) AS maxDiem
	FROM dbo.DMMonHoc INNER JOIN dbo.KetQua ON KetQua.MaMH = DMMonHoc.MaMH
	GROUP BY DMMonHoc.MaMH) AS temp
WHERE Diem = temp.maxDiem AND DMMonHoc.MaMH = temp.MaMH
GO
SELECT * FROM Cau7
GO
-- Câu 8: Tạo view đưa ra những sinh viên chưa thi môn cơ sở dữ liệu.
CREATE VIEW Cau8
AS
SELECT * 
FROM dbo.DSSinhVien
WHERE DSSinhVien.MaSV NOT IN (SELECT MaSV
	FROM dbo.KetQua 
	WHERE MaMH = 01
	GROUP BY MaSV)
GO
SELECT * FROM dbo.Cau8
GO
	
-- Câu 9: Tạo view đưa ra thông tin những sinh viên không trượt môn nào.
CREATE VIEW Cau9
as
SELECT *
FROM dbo.DSSinhVien
WHERE MaSV NOT IN (SELECT MaSV
	FROM dbo.KetQua
	WHERE Diem < 4
	GROUP BY MaSV)
GO
SELECT * FROM Cau9
GO

----------------------------BÀI 2----------------------------------
