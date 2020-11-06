create database QuanLyKhachSan

use QuanLyKhachSan

-- bang dang nhap
create table dangNhap
(
	tenDangNhap varchar(50) primary key,
	matKhau varchar(10)
)

-- bang nhan vien
create table nhanVien
(
	maNhanVien varchar(10) primary key not null,
	tenDangNhap varchar(50) foreign key (tenDangNhap) references dangNhap(tenDangNhap),
	hoNhanVien nvarchar(30), -- moi them
	tenNhanVien nvarchar(30), -- moi them
	ngaySinh Date check (ngaySinh < getdate()),
	ngayVaoLam Date check (ngayVaoLam < getdate()), -- moi them
	gioiTinh varchar(10),
	cmnd_NV int,
	soDienThoai_NV int,
	diaChi nvarchar(100),
	chucVu nvarchar(50),	
	matKhau varchar(10)
)

--bang dich vu
create table dichVu
(
	maDichVu varchar(10) primary key not null,
	tenDichVu nvarchar(50)
)

--bang quan ly tinh trang phong
create table trangThaiPhong
(
	maTrangThai nvarchar(50) primary key,
	loaiPhong nvarchar(50)
)

--bang quan ly phong
create table quanLyPhong
(
	maPhong varchar(10) primary key not null,
	maTrangThai nvarchar(50) foreign key (maTrangThai) references trangThaiPhong(maTrangThai),
	tenPhong nvarchar(50),
	giaPhongTheoGio float,
	giaPhongTheoNgay float,
	loaiPhong nvarchar(50),
	maDichVu varchar(10) foreign key (maDichVu) references dichVu(maDichVu),
	tinhTrangPhong nvarchar(50), -- true: fase
	chuThich nvarchar(100)
)

--bang quan ly khach hang
create table QLkhachHang
(
	maKhachHang varchar(10) primary key not null CONSTRAINT IDKH DEFAULT DBO.AUTO_IDKH(),
	maPhong varchar(10) foreign key (maPhong) references quanLyPhong(maPhong),
	tenKhachHang nvarchar(50),
	quocTich nvarchar(50),
	soDienThoai_KH int,
	gioiTinh varchar(20),
	cmnd_KH int,
	tuoi int
)

--bang hoa don
create table hoaDon
(
	maHoaDon varchar(10) primary key not null constraint IDHD default dbo.AUTO_IDHD(),
	maKhachHang varchar(10) foreign key (maKhachHang) references QLkhachHang(maKhachHang),
	maNhanVien varchar(10) foreign key (maNhanVien) references nhanVien(maNhanVien), -- moi them, do ben northwind co ghi vao ma co keu minh lam theo no
	ngayLapHoaDon date check (ngayLapHoaDon >= getdate()), -- moi them, y chang nhu tren
	gioDatPhong time,
	gioTraPhong time
)

--bang chi tiet hoa don
create table CT_hoadon
(
	maHoaDon varchar(10) foreign key(maHoaDon) references hoaDon(maHoaDon),
	maNhanVien varchar(10) foreign key (maNhanVien) references nhanVien(maNhanVien),
	maPhong varchar(10) foreign key (maPhong) references quanLyPhong(maPhong),
	tenKhachHang nvarchar(50), -- moi them
	ngayDen date check (ngayDen >= getdate()),
	ngayDi date, --check (ngayDi > ngayDen) foreign (ngayDen) references CT_hoadon(ngayDen),
	giaPhongTheoGio float,
	giaPhongTheoNgay float,
	hinhThucThuePhong nvarchar(255),
	tongTien float
)



-- cac trans tao ma khach hang, ma phong,... tu tang va co chu dau tien
CREATE FUNCTION AUTO_IDKH()
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ID VARCHAR(10)
	IF (SELECT COUNT(maKhachHang) FROM QLkhachHang) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(maKhachHang, 3)) FROM QLkhachHang
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'KH00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'KH0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END

--ma hoa don
CREATE FUNCTION AUTO_IDHD()
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ID VARCHAR(10)
	IF (SELECT COUNT(maHoaDon) FROM hoaDon) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(maHoaDon, 3)) FROM hoaDon
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'HD00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'HD0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END