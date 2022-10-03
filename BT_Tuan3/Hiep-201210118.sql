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

select *
from Cau3
-- Câu 4: Tạo view gồm những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên,
-- Tuổi, Tên khoa.
create view Cau4 as 
select HoSV, TenSV, convert(int, DATEDIFF(DD, NgaySinh, getDate())/365.25) as tuoi, TenKhoa
from DSSinhVien join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
where DATEDIFF(DD, NgaySinh, getDate())/365.25 >= 20 
	and DATEDIFF(DD, NgaySinh, getDate())/365.25 <= 25

select * from Cau4
-- Câu 5: Tạo view cho biết thông tin về mức học bổng của các sinh viên, gồm: 
-- Mã sinh viên, Phái, Mã khoa, Mức học bổng. 
-- Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao”
-- nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”
create view Cau5 as
select MaSV, Phai, MaKhoa, 
(
	case 
	when HocBong > 500000 then N'Học bổng cao'
	else N'Mức trung bình'
	end
) as MucHocBong
from DSSinhVien
where HocBong > 0

select * from Cau5

-- Câu 6: Tạo view đưa ra thông tin những sinh viên có học bổng lớn hơn bất kỳ học bổng của
-- sinh viên học khóa anh văn
create view Cau6 as
select MaSV, HoSV, TenSV, HocBong
from DSSinhVien inner join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
where hocbong > (select top (1) HocBong
					from DSSinhVien join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
					where TenKhoa = N'Anh Văn' 
					order by HocBong desc)
go
select * from Cau6
		