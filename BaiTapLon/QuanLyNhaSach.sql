CREATE DATABASE BTL_NHOM3_QLBanSach

CREATE TABLE tChucVu (
	MaChucVu NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tChucVu_MaChucVu PRIMARY KEY,
	TenChucVu NVARCHAR(20)
);

CREATE TABLE tNhanVien (
	MaNhanVien NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tNhanVien_MaNhanVien PRIMARY KEY,
	TenNhanVien NVARCHAR(20),
	GioiTinh BIT,
	NgaySinh DATE,
	SDT NVARCHAR(11),
	DiaChi NVARCHAR(30),
	MaChucVu NVARCHAR(15) NOT NULL
	CONSTRAINT FK_tNhanVien_MaChucVu FOREIGN KEY(MaChucVu) REFERENCES tChucVu(MaChucVu)
);

CREATE TABLE tKhachHang (
	MaKhachHang NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tKhachHang_MaKhachHang PRIMARY KEY,
	TenKhachHang NVARCHAR(20),
	SDT NVARCHAR(11),
	Email NVARCHAR(15),
	DiaChi NVARCHAR(30)
);

CREATE TABLE tTheLoai (
	MaTheLoai NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tTheLoai_MaTheLoai PRIMARY KEY,
	TenTheLoai NVARCHAR(20)
);

CREATE TABLE tNhaXuatBan (
	MaNXB NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tNhaXuatBan_MaNXB PRIMARY KEY,
	TenNXB NVARCHAR(20),
	Email NVARCHAR(15),
	DiaChi NVARCHAR(50)
);

CREATE TABLE tSach (
	MaSach NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tSach_MaSach PRIMARY KEY,
	TenSach NVARCHAR(20),
	TacGia NVARCHAR(20),
	MaNXB NVARCHAR(15) NOT NULL,
	MaTheLoai NVARCHAR(15) NOT NULL,
	TenDichGia NVARCHAR(20),
	SoTrang INT,
	KhoSach VARCHAR(20),
	NgayPhatHanh DATE,
	SoLuong INT,
	DonGiaBan MONEY,
	DonGiaNhap MONEY,
	CONSTRAINT FK_tSach_MaNXB
				FOREIGN KEY(MaNXB)
				REFERENCES tNhaXuatBan(MaNXB),
	CONSTRAINT FK_tSach_MaTheLoai
				FOREIGN KEY(MaTheLoai) 
				REFERENCES tTheLoai(MaTheLoai),
);

CREATE TABLE tHoaDonBan (
	MaHDB NVARCHAR(15) not null
	CONSTRAINT PK_HoaDonBan_MaHDB PRIMARY KEY,
	MaNhanVien NVARCHAR(15) not null,
	MaKhachHang NVARCHAR(15) not null,
	TongTien MONEY,
	CONSTRAINT FK_tHoaDonBan_MaNhanVien
				FOREIGN KEY(MaNhanVien)
				REFERENCES tNhanVien(MaNhanVien),
	CONSTRAINT FK_tHoaDonBan_MaKhachHang
				FOREIGN KEY(MaKhachHang) 
				REFERENCES tKhachHang(MaKhachHang),
);

create table tNhaCungCap(
	MaNCC NVARCHAR(15) not null
	CONSTRAINT PK_NhaCungCap_MaNCC PRIMARY KEY,
	TenNCC NVARCHAR(20)
);

CREATE TABLE tChiTietHoaDonBan (
	MaHDB NVARCHAR(15) not null,
	MaSach NVARCHAR(15) not null,
	SoLuong INT,
	DonGiaBan MONEY,
	GiamGia FLOAT,
	ThanhTien MONEY,
	CONSTRAINT PK_tChiTietHoaDonBan PRIMARY KEY(MaHDB, MaSach),
	CONSTRAINT FK_tChiTietHoaDonBan_MaHoaDon
				FOREIGN KEY(MaHDB)
				REFERENCES tHoaDonBan(MaHDB),
	CONSTRAINT FK_tChiTietHoaDonBan_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);

CREATE TABLE tHoaDonNhap (
	MaHDN NVARCHAR(15) not null 
	CONSTRAINT PK_tHoaDonNhap_MaHDN PRIMARY KEY,
	MaNhanVien NVARCHAR(15) not null,
	NgayNhap DATE,
	DonGiaNhap MONEY,
	ThanhTien MONEY,
	MaNCC NVARCHAR(15),
	CONSTRAINT FK_tHoaDonNhap_MaNCC
				FOREIGN KEY(MaNCC)
				REFERENCES tNhaCungCap(MaNCC),
	CONSTRAINT FK_tHoaDonNhap_MaNhanVien
			FOREIGN KEY(MaNhanVien)
			REFERENCES tNhanVien(MaNhanVien)

);

CREATE TABLE tChiTietHoaDonNhap (
	MaHDN NVARCHAR(15) not null,
	MaSach NVARCHAR(15) not null,
	SoLuong INT,
	DonGiaNhap MONEY,
	GiamGia FLOAT,
	ThanhTien MONEY,
	CONSTRAINT PK_tChiTietHoaDonNhap PRIMARY KEY(MaHDN, MaSach),
	CONSTRAINT FK_tChiTietHoaDonNhap_MaHDN
				FOREIGN KEY(MaHDN)
				REFERENCES tHoaDonNhap(MaHDN),
	CONSTRAINT FK_tChiTietHoaDonNhap_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);

CREATE TABLE tPhieuNhapKho (
	MaPhieuNK NVARCHAR(15) not null
	CONSTRAINT PK_tPhieuNhapKho_MaPhieuNK PRIMARY KEY,
	MaNhanVien NVARCHAR(15) not null,
	NgayNhap date,
	CONSTRAINT FK_tPhieuNhapKho_MaNhanVien
				FOREIGN KEY(MaNhanVien)
				REFERENCES tNhanVien(MaNhanVien)
);

CREATE TABLE tChiTietNhapKho(
	MaPhieuNK NVARCHAR(15) NOT NULL,
	MaSach NVARCHAR(15) not null,
	SoLuong INT,
	DonGiaNhap MONEY,
	CONSTRAINT PK_tChiTietNhapKho PRIMARY KEY(MaPhieuNK, MaSach),
	CONSTRAINT FK_tChiTietNhapKho_MaPhieuNK
				FOREIGN KEY(MaPhieuNK)
				REFERENCES tHoaDonBan(MaHDB),
	CONSTRAINT FK_tChiTietNhapKho_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);

CREATE TABLE tPhieuXuatKho (
	MaPhieuXK NVARCHAR(15) not null
	CONSTRAINT PK_tPhieuXuatKho_MaPhieuXK PRIMARY KEY,
	MaNhanVien NVARCHAR(15) not null,
	NgayXuat DATE,
	CONSTRAINT FK_tPhieuXuatKho_MaNhanVien
				FOREIGN KEY(MaNhanVien)
				REFERENCES tNhanVien(MaNhanVien)
);

CREATE TABLE tChiTietPhieuXuatKho(
	MaPhieuXK NVARCHAR(15) NOT NULL,
	MaSach NVARCHAR(15) NOT NULL,
	SoLuong INT,
	DonGiaXuat MONEY,
	CONSTRAINT PK_tChiTietPhieuXuatKho PRIMARY KEY(MaPhieuXK, MaSach),
	CONSTRAINT FK_tChiTietPhieuXuatKho_MaPhieuXK
				FOREIGN KEY(MaPhieuXK)
				REFERENCES tPhieuXuatKho(MaPhieuXK),
	CONSTRAINT FK_tChiTietPhieuXuatKho_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);
GO

INSERT dbo.tSach
(
    MaSach,
    TenSach,
    TacGia,
    MaNXB,
    MaTheLoai,
    TenDichGia,
    SoTrang,
    KhoSach,
    NgayPhatHanh,
    SoLuong,
    DonGiaBan,
    DonGiaNhap
)
VALUES
(   N'S01
',       -- MaSach - nvarchar(15)
	N'Cha giàu cha nghèo', 
    N'Robert T.Kiyosaki',       -- TacGia - nvarchar(20)
    N'NXB01',       -- MaNXB - nvarchar(15)
    N'TL01',       -- MaTheLoai - nvarchar(15)
    N'Tạ Nguyễn Tấn Trương',       -- TenDichGia - nvarchar(20)
    414,         -- SoTrang - int
    '14x20cm',        -- KhoSach - varchar(20)
    '2010-09-12', -- NgayPhatHanh - date
    100,         -- SoLuong - int
    145000,      -- DonGiaBan - money
    120000       -- DonGiaNhap - money
    )
GO

INSERT dbo.tNhaXuatBan
(
    MaNXB,
    TenNXB,
    Email,
    DiaChi
)
VALUES
(   N'NXB01', -- MaNXB - nvarchar(15)
    N'NXB Trẻ', -- TenNXB - nvarchar(20)
    N'tre@gmail.com', -- Email - nvarchar(15)
    N'Hà Nội'  -- DiaChi - nvarchar(50)
    )
GO

INSERT dbo.tTheLoai
(
    MaTheLoai,
    TenTheLoai
)
VALUES
(   N'TL01', -- MaTheLoai - nvarchar(15)
    N'Tiểu thuyết'  -- TenTheLoai - nvarchar(20)
    )
GO