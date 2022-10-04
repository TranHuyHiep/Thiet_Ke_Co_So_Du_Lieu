-- Câu 1: Tạo View danh sách sinh viên, gồm các thông tin sau:
--Mã sinh viên, Họ sinh viên, Tên sinh viên, Học bổng
use [BT_Tuan3]

create view Cau1 as
select MaSV, HoSV, TenSV, HocBong
from DSSinhVien 

select *
from Cau1
-- Câu 2: Tạo view Liệt kê các sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội, gồm
-- các thông tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
create view Cau2 as
select HoSV, TenSV, MaSV, NoiSinh, HocBong
from DSSinhVien
where HocBong >= 150000 and NoiSinh = N'Hà Nội'

select *
from Cau2
-- Câu 3: Tạo view liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông
-- tin: Mã sinh viên, Họ tên sinh viên, tên khoa, Phái
create view Cau3 as
select MaSV, HoSV, TenSV, TenKhoa, Phai
from DSSinhVien join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
where (TenKhoa = N'Tin Học' or TenKhoa = N'Anh Văn') and Phai = N'Nam'

SELECT *
FROM Cau3
-- Câu 4: Tạo view gồm những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên,
-- Tuổi, Tên khoa.
CREATE VIEW Cau4 AS 
SELECT HoSV, TenSV, CONVERT(INT, DATEDIFF(DD, NgaySinh, GETDATE())/365.25) AS tuoi, TenKhoa
FROM DSSinhVien JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
WHERE DATEDIFF(DD, NgaySinh, GETDATE())/365.25 >= 20 
	AND DATEDIFF(DD, NgaySinh, GETDATE())/365.25 <= 25

SELECT * FROM Cau4
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

SELECT * FROM Cau5

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

-- Câu 7: Tạo view đưa ra thông tin những sinh viên đạt điểm cao nhất trong từng môn. (chua xong)
SELECT DMMonHoc.MaMH, TenMH, t.HoSV, t.TenSV, t.Diem
FROM DMMonHoc JOIN (SELECT DSSinhVien.MaSV, HoSV, TenSV, Phai, NgaySinh, NoiSinh, Diem, MaMH
					FROM KetQua JOIN DSSinhVien ON KetQua.MaSV = DSSinhVien.MaSV
					ORDER BY Diem DESC) AS t ON t.MaMH = DMMonHoc.MaMH


SELECT DSSinhVien.MaSV, HoSV, TenSV, Phai, NgaySinh, NoiSinh, Diem, MaMH
FROM KetQua JOIN DSSinhVien ON KetQua.MaSV = DSSinhVien.MaSV
ORDER BY Diem DESC

SELECT *
FROM dbo.DMMonHoc

-- Câu 8: Tạo view đưa ra những sinh viên chưa thi môn cơ sở dữ liệu.

-- Câu 9: Tạo view đưa ra thông tin những sinh viên không trượt môn nào.

		