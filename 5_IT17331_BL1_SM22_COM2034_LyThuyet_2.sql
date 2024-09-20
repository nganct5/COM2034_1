-- Các phím tắt cơ bản Azure:
-- Ctrl + /: Dùng comment code
-- F5: Dùng để chạy câu lệnh SQL

-- Sử dụng SQL: 
-- Chạy câu lệnh SQL đang được chọn (Ctrl + E)
-- Chuyển câu lệnh đang chọn thành chữ hoa, chữ thường (Ctrl + Shift + U, Ctrl + Shift + L)
-- Comment và bỏ comment dòng lệnh ( Ctrl + K + C; Ctrl + K + U)

-- Bài 1 Tạo biến bằng lệnh Declare trong SQL SERVER
-- 1.1 Để khai báo biến thì các bạn sử dụng từ khóa Declare với cú pháp như sau:
-- DECLARE @var_name data_type;
-- @var_name là tên của biến, luôn luôn bắt đầu bằng ký tự @
-- data_type là kiểu dữ liệu của biến
-- Ví dụ:
DECLARE @YEAR AS INT
DECLARE @a1 AS INT, @a2 AS VARCHAR

-- 1.2 Gán giá trị cho biến
-- SQL Server để gán giá trị thì bạn sử dụng từ khóa SET và toán tử = với cú pháp sau
-- SET @var_name = value
SET @YEAR = 2022

-- 1.2 Truy xuất giá trị của biến SELECT @<Tên biến> 
SELECT @YEAR
-- 2 Bài: Tính tổng 3 số và tính diện tích hình chữ nhật.
DECLARE @b1 INT, @b2 INT, @b3 INT
SET @b1 = 1
SET @b2 = 1
SET @b3 = 1
SELECT (@b1 + @b2 + @b3)

-- 1.3 Lưu trữ câu truy vấn vào biến
DECLARE @SLTonMax INT
SET @SLTonMax = (SELECT MAX(SoLuongTon) FROM ChiTietSP)
--SELECT @SLTonMax
PRINT N'Số lượng SP tồn kho lớn nhất là: ' + CONVERT(VARCHAR,@SLTonMax)

-- 1.4 Biến bảng
DECLARE @TB_NhanVien TABLE(Id INT,MaNV VARCHAR(50),TenNV NVARCHAR(50))

INSERT INTO @TB_NhanVien
SELECT Id,Ma,Ten FROM NhanVien
WHERE Ten LIKE 'T%'

SELECT * FROM @TB_NhanVien

DECLARE @TB_SinhVien TABLE(Id INT,Ma VARCHAR(50),Ten NVARCHAR(50))
INSERT INTO @TB_SinhVien
VALUES(1,'PH123',N'Tồn')
SELECT * FROM @TB_SinhVien
-- Sửa tên Tồn => FPOLY
UPDATE @TB_SinhVien
SET Ten = 'FPOLY'
WHERE Id = 1
SELECT * FROM @TB_SinhVien

-- 1.7 Begin và End
/* T-SQL tổ chức theo từng khối lệnh
   Một khối lệnh có thể lồng bên trong một khối lệnh khác
   Một khối lệnh bắt đầu bởi BEGIN và kết thúc bởi
   END, bên trong khối lệnh có nhiều lệnh, và các
   lệnh ngăn cách nhau bởi dấu chấm phẩy	
   BEGIN
    { sql_statement | statement_block}
   END
*/
BEGIN
	SELECT Id,SoLuongTon,GiaNhap 
	FROM ChiTietSP
	WHERE SoLuongTon > 900

	IF @@ROWCOUNT =0
	PRINT N'Không có sản phẩm tồn lớn hơn 1000'
	ELSE
	PRINT N'Có sản phẩm thỏa mãn lớn hơn 1000'
END

-- 1.8 Begin và End lồng nhau
BEGIN
	DECLARE @Ten NVARCHAR(50)
	SELECT TOP 1
	@Ten = Ten
	FROM NhanVien
	WHERE Ten = N'Thụ'
	ORDER BY Ten

	IF @@ROWCOUNT <>0
	BEGIN
		PRINT N'Tìm thấy người đầu tiên có tên: ' + @Ten
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy người nào có tên như vậy'
	END
END

-- 1.9 CAST ÉP KIỂU DỮ LIỆU
-- Hàm CAST trong SQL Server chuyển đổi một biểu thức từ một kiểu dữ liệu này sang kiểu dữ liệu khác. 
-- Nếu chuyển đổi không thành công, CAST sẽ báo lỗi, ngược lại nó sẽ trả về giá trị chuyển đổi tương ứng.
-- CAST(bieuthuc AS kieudulieu [(do_dai)])
SELECT CAST(1.2 AS INT)--= 1
SELECT CAST(2.3 AS FLOAT)
SELECT CAST(4.6 AS VARCHAR(50))
SELECT CAST('4.9' AS FLOAT)
SELECT CAST('2022-01-15' AS DATE)

-- 2.0 CONVERT 
-- Hàm CONVERT trong SQL Server cho phép bạn có thể chuyển đổi một biểu thức nào đó sang một kiểu dữ liệu 
-- bất kỳ mong muốn nhưng có thể theo một định dạng nào đó (đặc biệt đối với kiểu dữ liệu ngày). 
-- Nếu chuyển đổi không thành công, CONVERT sẽ báo lỗi, ngược lại nó sẽ trả về giá trị chuyển đổi tương ứng.
-- CONVERT(kieudulieu(do_dai), bieuthuc, dinh_dang)
-- dinh_dang (không bắt buộc): là một con số chỉ định việc định dạng cho việc chuyển đổi dữ liệu từ dạng ngày sang dạng chuỗi.
-- Các định dạng trong convert 101,102.........các tham số định dạng https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

SELECT CONVERT(int,14.3)--=14
SELECT CONVERT(float,'10.3')
SELECT CONVERT(datetime,'2022-05-21')
SELECT CONVERT(varchar,'05/21/2022',101)
SELECT CONVERT(date,'2022.05.22',102)
SELECT CONVERT(date,'21/05/2022',103)

-- Ví dụ. Hiển thị ngày tháng năm sinh của nhân viên
SELECT NgaySinh,
	CAST(NgaySinh AS VARCHAR) AS N'Ngày sinh 1',
	CONVERT(VARCHAR,NgaySinh,101) AS '101',
	CONVERT(VARCHAR,NgaySinh,102) AS '102',
	CONVERT(VARCHAR,NgaySinh,103) AS '103'
FROM NhanVien

-- 2.1 Các hàm toán học Các hàm toán học (Math) được dùng để thực hiện các phép toán số học trên các giá trị. 
-- Các hàm toán học này áp dụng cho cả SQL SERVER và MySQL.
-- 1. ABS() Hàm ABS() dùng để lấy giá trị tuyệt đối của một số hoặc biểu thức.
-- Hàm ABS() dùng để lấy giá trị tuyệt đối của một số hoặc biểu thức.
SELECT ABS(-3)
-- 2. CEILING()
-- Hàm CEILING() dùng để lấy giá trị cận trên của một số hoặc biểu thức, tức là lấy giá trị số nguyên nhỏ nhất nhưng lớn hơn số hoặc biểu thức tương ứng.
-- CEILING(num_expr)
SELECT CEILING(3.1)
-- 3. FLOOR()
-- Ngược với CEILING(), hàm FLOOR() dùng để lấy cận dưới của một số hoặc một biểu thức, tức là lấy giá trị số nguyên lớn nhất nhưng nhỏ hơn số hoặc biểu thức tướng ứng.
-- FLOOR(num_expr)
SELECT FLOOR(9.9)
-- 4. POWER()
-- POWER() dùng để tính luỹ thừa của một số hoặc biểu thức.
-- POWER(num_expr,luỹ_thừa)
SELECT POWER(3,2)
-- 5. ROUND()
-- Hàm ROUND() dùng để làm tròn một số hay biểu thức.
-- ROUND(num_expr,độ_chính_xác)
SELECT ROUND(9.123456,2)-- = 9.123500
-- 6. SIGN()
-- Hàm SIGN() dùng để lấy dấu của một số hay biểu thức. Hàm trả về +1 nếu số hoặc biểu thức có giá trị dương (>0),
-- -1 nếu số hoặc biểu thức có giá trị âm (<0) và trả về 0 nếu số hoặc biểu thức có giá trị =0.
SELECT SIGN(-99)
SELECT SIGN(100-50)
-- 7. SQRT()
-- Hàm SQRT() dùng để tính căn bậc hai của một số hoặc biểu thức, giá trị trả về của hàm là số có kiểu float.
-- Nếu số hay biểu thức có giá trị âm (<0) thì hàm SQRT() sẽ trả về NULL đối với MySQL, trả về lỗi đối với SQL SERVER.
-- SQRT(float_expr)
SELECT SQRT(9)
SELECT SQRT(9-5)
-- 8. SQUARE()
-- Hàm này dùng để tính bình phương của một số, giá trị trả về có kiểu float. Ví dụ:
SELECT SQUARE(9)
-- 9. LOG()
-- Dùng để tính logarit cơ số E của một số, trả về kiểu float. Ví dụ:
SELECT LOG(9) AS N'Logarit cơ số E của 9'
-- 10. EXP()
-- Hàm này dùng để tính luỹ thừa cơ số E của một số, giá trị trả về có kiểu float. Ví dụ:
SELECT EXP(2)
-- 11. PI()
-- Hàm này trả về số PI = 3.14159265358979.
SELECT PI()
-- 12. ASIN(), ACOS(), ATAN()
-- Các hàm này dùng để tính góc (theo đơn vị radial) của một giá trị. Lưu ý là giá trị hợp lệ đối với 
-- ASIN() và ACOS() phải nằm trong đoạn [-1,1], nếu không sẽ phát sinh lỗi khi thực thi câu lệnh. Ví dụ:
SELECT ASIN(1) as [ASIN(1)], ACOS(1) as [ACOS(1)], ATAN(1) as [ATAN(1)];

-- 2.2 Các hàm xử lý chuỗi làm việc với kiểu chuỗi
/*
 LEN(string)  Trả về số lượng ký tự trong chuỗi, tính cả ký tự trắng đầu chuỗi
 LTRIM(string) Loại bỏ khoảng trắng bên trái
 RTRIM(string)  Loại bỏ khoảng trắng bên phải
 LEFT(string,length) Cắt chuỗi theo vị trí chỉ định từ trái
 RIGHT(string,legnth) Cắt chuỗi theo vị trí chỉ định từ phải
 TRIM(string) Cắt chuỗi 2 đầu nhưng từ bản SQL 2017 trở lên mới hoạt động
*/
SELECT LEN('SQL SERVER')--= 10
SELECT LTRIM('    SQL SERVER')
SELECT RTRIM('    SQL SERVER     ')
SELECT RTRIM(LTRIM('   SQL SERVER     '))-- Loại bỏ khoảng trắng 2 đầu cách cũ

/*Nếu chuỗi gồm hai hay nhiều thành phần, bạn có thể phân
tách chuỗi thành những thành phần độc lập.
Sử dụng hàm CHARINDEX để định vị những ký tự phân tách.
Sau đó, dùng hàm LEFT, RIGHT, SUBSTRING và LEN để trích ra
những thành phần độc lập*/
DECLARE  @TB_NAMES TABLE(Ten NVARCHAR(MAX))
INSERT INTO @TB_NAMES
VALUES(N'Nguyễn Bá Tồn'),(N'Võ Văn Kiệt')
SELECT Ten,
	LEN(Ten) AS N'Độ Dài chuỗi',
	CHARINDEX(' ',Ten) AS 'CHARINDEX',
	LEFT(Ten,CHARINDEX(' ',Ten) -1) AS N'Họ',
	RIGHT(Ten,LEN(Ten) - CHARINDEX(' ',Ten)) AS N'Tên'
FROM @TB_NAMES
-- Thử tách nốt thành phần tên thành tên đệm và tên. - 10h30

-- 2.3 Charindex Trả về vị trí được tìm thấy của một chuỗi trong chuỗi chỉ định, 
-- ngoài ra có thể kiểm tra từ vị trí mong  muốn
-- CHARINDEX ( string1, string2 ,[  start_location ] ) = 1 số nguyên
SELECT CHARINDEX('POLY','FPT POLYTECHNIC')
SELECT CHARINDEX('POLY','FPT POLYTECHNIC',3)

-- 2.4 Substring Cắt chuỗi bắt đầu từ vị trí và độ dài muốn lấy 
-- SUBSTRING(string,start,length)
SELECT SUBSTRING('FPT POLYTECHNIC',5,LEN('FPT POLYTECHNIC'))
SELECT SUBSTRING('FPT POLYTECHNIC',5,8)

-- 2.5 Replace Hàm thay thế chuỗi theo giá trị cần thay thế và cần thay thế
-- REPLACE(search,find,replace)
SELECT REPLACE('0912-345-678','-','_')

/* 2.6 
REVERSE(string) Đảo ngược chuỗi truyền vào
LOWER(string)	Biến tất cả chuỗi truyền vào thành chữ thường
UPPER(string)	Biến tất cả chuỗi truyền vào thành chữ hoa
SPACE(integer)	Đếm số lượng khoảng trắng trong chuỗi. 
*/
SELECT LOWER('SQL SERVER 2022')
SELECT UPPER('sql server')
SELECT REVERSE('sql')
SELECT N'Nguyễn' + '  ' + N'Dũng'
SELECT N'Nguyễn' + SPACE(10) + N'Dũng'

-- 2.7 Các hàm ngày tháng năm
SELECT GETDATE()
SELECT CONVERT(DATE,GETDATE())
SELECT CONVERT(TIME,GETDATE())

SELECT YEAR(GETDATE()) AS YEAR,
	MONTH(GETDATE()) AS MONTH,
	DAY(GETDATE()) AS DAY

-- DATENAME: truy cập tới các thành phần liên quan ngày tháng
SELECT DATENAME(YEAR,GETDATE()) AS YEAR,
		DATENAME(MONTH,GETDATE()) AS MONTH,
		DATENAME(DAY,GETDATE()) AS DAY,
		DATENAME(WEEK,GETDATE()) AS WEEK,
		DATENAME(DAYOFYEAR,GETDATE()) AS DAYOFYEAR,
		DATENAME(WEEKDAY,GETDATE()) AS WEEKDAY
-- Truyền ngày sinh của bản thân vào 
DECLARE @Ngay_Sinh_Cua_Toi DATE
SET @Ngay_Sinh_Cua_Toi = '1980-07-27'
SELECT DATENAME(YEAR,@Ngay_Sinh_Cua_Toi) AS YEAR,
		DATENAME(MONTH,@Ngay_Sinh_Cua_Toi) AS MONTH,
		DATENAME(DAY,@Ngay_Sinh_Cua_Toi) AS DAY,
		DATENAME(WEEK,@Ngay_Sinh_Cua_Toi) AS WEEK,
		DATENAME(DAYOFYEAR,@Ngay_Sinh_Cua_Toi) AS DAYOFYEAR,
		DATENAME(WEEKDAY,@Ngay_Sinh_Cua_Toi) AS WEEKDAY

-- 2.8 Câu điều kiện IF ELSE trong SQL
/* Lệnh if sẽ kiểm tra một biểu thức có đúng  hay không, nếu đúng thì thực thi nội dung bên trong của IF, nếu sai thì bỏ qua.
IF BIỂU THỨC   
BEGIN
    { statement_block }
END		  */
IF 1=2
BEGIN
	PRINT N'Đúng'
END
ELSE
BEGIN
	PRINT N'SAI'
END

IF 1=1
	PRINT N'Đúng'
ELSE
	PRINT N'SAI'

-- Viết 1 chương trình tính điểm thi Qua môn  
DECLARE @DiemThi_COM2034 FLOAT
SET @DiemThi_COM2034 = 9
IF @DiemThi_COM2034 < 5
	PRINT N'Chúc mừng bạn vừa mất 700k'
ELSE IF(@DiemThi_COM2034 < 7)
	PRINT N'Chúc mừng bạn vừa mất 300K'
ElSE
	PRINT N'Chúc mừng bạn vừa không mất 700k'

-- Về nhà làm bài tập: Tính điểm trung bình môn SQL theo các điều kiện sau: XUẤT SẮC, GIỎI, KHÁ, TRUNG BÌNH, HỌC LẠI.

/* 2.9 IF EXISTS
IF EXISTS (CaulenhSELECT)
Cau_lenhl | Khoi_lenhl
[ELSE
Cau_lenh2 | Khoi_lenh2] 
*/
-- Kiểm tra xem trong bảng chi tiết sản phẩm có sản phẩm nào số lượng tồn lớn hơn 900
IF EXISTS(
	SELECT * FROM ChiTietSP
	WHERE SoLuongTon > 900)
	BEGIN
		PRINT N'Có danh sách sản phẩm lớn hơn 900 tồn'
		SELECT * FROM ChiTietSP
		WHERE SoLuongTon > 900
	END
ELSE 
BEGIN
	PRINT N'Không Có danh sách sản phẩm lớn hơn 900 tồn'
END
/*
 3.0 Hàm IIF () trả về một giá trị nếu một điều kiện là TRUE hoặc một giá trị khác nếu một điều kiện là FALSE.
IIF(condition, value_if_true, value_if_false)
*/
SELECT IIF(5>9,N'Đúng',N'Sai')

SELECT Ma,Ten,
	IIF(IdCH = 1,N'Nhân viên thuộc CH1',IIF(IdCH = 2,N'Nhân viên thuộc CH2',N'Không xác định'))
FROM NhanVien

/*
3.1 Câu lệnh CASE đi qua các điều kiện và trả về một giá trị khi điều kiện đầu tiên được đáp ứng (như câu lệnh IF-THEN-ELSE). 
Vì vậy, một khi một điều kiện là đúng, nó sẽ ngừng đọc và trả về kết quả. 
Nếu không có điều kiện nào đúng, nó sẽ trả về giá trị trong mệnh đề ELSE.
Nếu không có phần ELSE và không có điều kiện nào đúng, nó sẽ trả về NULL.
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
*/
-- Cách 1
SELECT 
	Ten = CASE GioiTinh
			WHEN 'Nam' THEN 'Anh. ' + Ten
			WHEN N'Nữ' THEN N'Chị. ' + Ten
			ELSE N'Không xác định. ' + Ten
			END
FROM NhanVien
-- Cách 2
SELECT 
	Ten = CASE 
			WHEN GioiTinh = 'Nam' THEN 'Anh. ' + Ten
			WHEN GioiTinh = N'Nữ' THEN N'Chị. ' + Ten
			ELSE N'Không xác định. ' + Ten
			END
FROM NhanVien
-- Ví dụ về tính lương nhân viên.
DECLARE @TB_NV TABLE(MaNV VARCHAR(50),Luong FLOAT)
INSERT INTO @TB_NV
VALUES('Dungna',5000000),('Minhdq',10000000),('Tiennh',7000000),('Thiennh',6000000)
--Sử dụng CASE WHEN THEN tính thuế thu nhập theo điều kiện sau 1=> 5tr mức 5%, 6tr đến 7tr => 10%, Trên 10tr => 15% thuê. Hãy tạo ra cột ính thuế thu nhập cho bảng tạm trên.
SELECT MaNV,Luong,
(
CASE
WHEN Luong <= 5000000 THEN Luong*0.05
WHEN Luong >= 5000000 AND Luong <= 7000000  THEN Luong*0.1
ELSE Luong*0.15
END
)AS N'Thuế'
FROM @TB_NV
/*Vòng lặp WHILE (WHILE LOOP) được sử dụng nếu bạn muốn 
chạy lặp đi lặp lại một đoạn mã khi điều kiện cho trước trả về giá trị là TRUE.*/
DECLARE @DEM INT = 0
WHILE @DEM < 5
BEGIN
	PRINT N'MÔN CSDL NÂNG CAO QUAN TRỌNG PHẢI CHỊU KHÓ CODE'
	PRINT N'LẦN CHẠY' + CONVERT(VARCHAR, @DEM)
	SET @DEM = @DEM +1
END

/*Lệnh Break (Ngắt vòng lặp)*/
/* Lệnh Continue: Thực hiện bước lặp tiếp theo bỏ qua các lệnh trong */
DECLARE @DEM INT = 0
WHILE @DEM < 10
BEGIN
	IF @DEM = 5
		BEGIN
			SET @DEM += 1
			CONTINUE
		END
	PRINT N'MÔN CSDL NÂNG CAO QUAN TRỌNG PHẢI CHỊU KHÓ CODE'
	PRINT N'LẦN CHẠY' + CONVERT(VARCHAR, @DEM)
	SET @DEM = @DEM +1
END
-- Lam chủ 1 vòng lặp cần 3 thứ sau:
-- 1. Điểm bắt đầu
-- 2. Điều kiện ngắt vòng lặp
-- 3. Bước nhẩy

/* 3.2 Try...Catch 
SQLServer Transact-SQL cung cấp cơ chế kiểm soát lỗi bằng TRY … CATCH
như trong các ngôn ngữ lập trình phổ dụng hiện nay (Java, C, PHP, C#).
Một số hàm ERROR thường dùng
_
ERROR_NUMBER() : Trả về mã số của lỗi dưới dạng số
ERROR_MESSAGE() Trả lại thông báo lỗi dưới hình thức văn bản 
ERROR_SEVERITY() Trả lại mức độ nghiêm trọng của lỗi kiểu int
ERROR_STATE() Trả lại trạng thái của lỗi dưới dạng số
ERROR_LINE() : Trả lại vị trí dòng lệnh đã phát sinh ra lỗi
ERROR_PROCEDURE() Trả về tên thủ tục/Trigger gây ra lỗi
*/
SELECT 1 + 'String'
BEGIN TRY
	SELECT 1 + 'String'
END TRY
BEGIN CATCH
	SELECT 
	ERROR_NUMBER() AS N'Trả về mã số của lỗi dưới dạng số',
	ERROR_MESSAGE() AS N'Trả lại thông báo lỗi dưới hình thức văn bản',
	ERROR_LINE() AS N'Trả lại vị trí dòng lệnh đã phát sinh ra lỗi'
END CATCH

-- Ví dụ 2:
BEGIN TRY
	INSERT INTO ChucVu VALUES ('NVaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',N'Nhân Viên')
END TRY
BEGIN CATCH
	PRINT N'Không insert thành công vào bảng chứcc vụ'
	PRINT N'Thông báo: ' + CONVERT(VARCHAR,ERROR_NUMBER())
	PRINT N'Thông báo: ' + ERROR_MESSAGE()
END CATCH
/* 3.3 RAISERROR
*/
-- CÓ dùng RAISERROR
BEGIN TRY
	INSERT INTO ChucVu VALUES ('NVaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',N'Nhân Viên')
END TRY
BEGIN CATCH
	DECLARE @erERROR_SEVERITY INT,@erERROR_MESSAGE VARCHAR(MAX),@erERROR_STATE INT
	SELECT
		@erERROR_SEVERITY = ERROR_SEVERITY(),
		@erERROR_MESSAGE = ERROR_MESSAGE(),
		@erERROR_STATE = ERROR_STATE()
	RAISERROR(@erERROR_MESSAGE,@erERROR_SEVERITY,@erERROR_STATE)
END CATCH
-- Không dùng
BEGIN TRY
	INSERT INTO ChucVu VALUES ('NVaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',N'Nhân Viên')
END TRY
BEGIN CATCH
	DECLARE @erERROR_SEVERITY INT,@erERROR_MESSAGE VARCHAR(MAX),@erERROR_STATE INT
	SELECT
		@erERROR_SEVERITY = ERROR_SEVERITY(),
		@erERROR_MESSAGE = ERROR_MESSAGE(),
		@erERROR_STATE = ERROR_STATE()
	PRINT N'Thông Báo: ' +  ERROR_MESSAGE() + ' | ' + CONVERT(VARCHAR,ERROR_SEVERITY()) + ' | ' + CONVERT(VARCHAR,ERROR_STATE())
END CATCH
-- 3.4 Ý nghĩa của Replicate
DECLARE @ten1234 NVARCHAR(50)
SET @ten1234 = REPLICATE(N'Á',5)--Lặp lại số lần với String truyền vào
PRINT @ten1234

/* TỔNG KẾT STORE PROCEDURE :
 -- Là lưu trữ một tập hợp các câu lệnh đi kèm trong CSDL cho phép tái sử dụng khi cần
 -- Hỗ trợ các ứng dụng tương tác nhanh và chính xác
 -- Cho phép thực thi nhanh hơn cách viết từng câu lệnh SQL
 -- Stored procedure có thể làm giảm bớt vấn đề kẹt đường truyền mạng, dữ liệu được gởi theo gói.
 -- Stored procedure có thể sử dụng trong vấn đề bảo mật, phân quyền
 -- Có 2 loại Store Procedure chính: System stored	procedures và User stored procedures   
 
 -- Cấu trúc của Store Procedure bao hồm:
	➢Inputs: nhận các tham số đầu vào khi cần
	➢Execution: kết hợp giữa các yêu cầu nghiệp vụ với các lệnh
	lập trình như IF..ELSE, WHILE...
	➢Outputs: trả ra các đơn giá trị (số, chuỗi…) hoặc một tập kết quả.
 
 --Cú pháp:
 CREATE hoặc ALTER(Để cập nhật nếu đã tồn tại tên SP) PROC <Tên STORE PROCEDURE> <Tham số truyền vào nếu có>
 AS
 BEGIN
  <BODY CODE>
 END
 ĐỂ GỌI SP dùng EXEC hoặc EXECUTE
SPs chia làm 2 loại:
System stored procedures: Thủ tục mà những người sử dụng chỉ có quyền thực hiện, không được phép thay đổi.	
User stored procedures: Thủ tục do người sử dụng tạo và thực hiện.
 -- SYSTEM STORED PROCEDURES
 Là những stored procedure chứa trong Master Database, thường bắt đầu bằng tiếp đầu ngữ	 sp_
 Chủ yếu dùng trong việc quản lý cơ sở dữ liệu(administration) và bảo mật (security).
❑Ví dụ: sp_helptext <tên của đối tượng> : để lấy định nghĩa của đối tượng (thông số tên đối
tượng truyền vào) trong Database
 */

 GO
 ALTER PROCEDURE SP_LayDSNhanVienNam
 AS
 SELECT * FROM NhanVien WHERE GioiTinh = N'Nữ'

-- Thực thi thì cần biết rõ tên của Store nào và có thể có 2 cách gõ
EXECUTE dbo.SP_LayDSNhanVienNam
EXEC dbo.SP_LayDSNhanVienNam

-- VIỆC TRIỂN KHAI ĐƯỢC STORE PROC GIÚP CÁC BẠN BÊN JAVA HỌC MÔN 3, DỰ ÁN 1, DỰ ÁN TỐT NGHIỆP DỄ HƠN.

-- Ví dụ 2:
GO
CREATE PROC SP_LayDSSanPhamCoDK(@NamBH INT,@SLT INT)
AS
SELECT Id,NamBH,MoTa,SoLuongTon,GiaNhap
FROM ChiTietSP WHERE NamBH = @NamBH AND SoLuongTon >= @SLT

EXEC SP_LayDSSanPhamCoDK @NamBH  = 2,@SLT = 600

-- Ví dụ 3: CRUD 1 BẢNG
GO
ALTER PROC SP_CRUDF_DongSP
		(@Id INT,
		@Ma VARCHAR(20),
		@Ten NVARCHAR(30),
		@SType VARCHAR(10))
AS
BEGIN
	IF(@SType = 'SELECT')	
	BEGIN
		SELECT * FROM DongSP
	END
	IF(@SType = 'INSERT')	
	BEGIN
		INSERT INTO DongSP VALUES(@Ma,@Ten)
	END
	IF(@SType = 'DELETE')	
	BEGIN
		DELETE FROM DongSP WHERE Id = @Id
	END
	IF(@SType = 'UPDATE')	
	BEGIN
		UPDATE DongSP SET
		Ma = @Ma,
		Ten = @Ten
		WHERE Id = @Id
	END
	IF(@SType = 'FIND')	
	BEGIN
		SELECT * FROM DongSP WHERE Ma = @Ma
	END
END
-- Thực thi
EXEC SP_CRUDF_DongSP @Id = 0,@Ma = '',@Ten = '',@SType = 'SELECT'
EXEC SP_CRUDF_DongSP @Id = 0,@Ma = 'DUNGNA29',@Ten = N'Dũng',@SType = 'INSERT'

DECLARE @myid uniqueidentifier = NEWID();
--002EED55-D45C-485F-8DD1-9666CAB3124B           
SELECT CONVERT(CHAR(255), @myid) AS 'char';  

 -- Bài Tập Viết STORE PROC CRUD BẢNG NHÂN VIÊN Không truyền khóa phụ mà là truyền mã MÃ CỬA HÀNG, MÃ CHỨC VỤ, Mã Người Gửi Báo. CÒN CÁC THAM SỐ HỢP LÝ.
 -- Thực thi đủ 4 câu CRUD thành công.
 -- 10h30 Sau đó gọi random code lại trên máy chiếu

ALTER PROC SP_CRUD_NV_2022
(@ID INT,@MA VARCHAR(20),@TEN NVARCHAR(30),@TENDEM NVARCHAR(30),
@HO NVARCHAR(30),@GIOITINH NVARCHAR(10),@NGAYSINH DATE,
@DIACHI NVARCHAR(100),@SDT VARCHAR(30),@MACH VARCHAR(20),
@MACV VARCHAR(20),@MANGBC VARCHAR(20),@TRANGTHAI INT,@STYPE VARCHAR(10))
AS
BEGIN
    BEGIN
        DECLARE @IDCH INT,@IDCV INT,@IDGBC INT
        SET @IDCH=(SELECT TOP 1 ID FROM CuaHang WHERE MA=@MACH)    
        SET @IDCV=(SELECT TOP 1 ID FROM ChucVu WHERE MA=@MACV)
        SET @IDGBC=(SELECT TOP 1 ID FROM NHANVIEN WHERE MA=@MANGBC)            
    END

    IF(@STYPE = 'SELECT')
    BEGIN
        SELECT *,CuaHang.Ma,ChucVu.Ma FROM NhanVien
        JOIN CuaHang ON NhanVien.IdCH = CuaHang.ID
        JOIN ChucVu ON NhanVien.IdCV = ChucVu.Id
    END

    IF(@STYPE='INSERT')
    BEGIN
        INSERT INTO NhanVien VALUES(@MA,@TEN,@TENDEM,
        @HO,@GIOITINH,@NGAYSINH,@DIACHI,@SDT,@IDCH,@IDCV,@IDGBC,
        @TRANGTHAI)
    END

    IF(@STYPE='UPDATE')
    BEGIN
        UPDATE NhanVien SET
        TEN=@TEN
        WHERE Id=@ID
    END

    IF(@STYPE='DELETE')
    BEGIN
        DELETE FROM NhanVien
        WHERE Id=@ID
    END
END

EXECUTE SP_CRUD_NV_2022 @ID =0,@MA ='1',@TEN ='CONG',@TENDEM ='THANH',
@HO ='NAM',@GIOITINH ='NAM',@NGAYSINH ='09/02/2003',
@DIACHI ='THAI BINH',@SDT ='1234567890',@MACH ='CH17',
@MACV ='CT',@MANGBC ='NV2',@TRANGTHAI =1,@STYPE ='INSERT'

EXECUTE SP_CRUD_NV_2022 @ID =0,@MA ='1',@TEN ='CONG',@TENDEM ='THANH',
@HO ='NAM',@GIOITINH ='NAM',@NGAYSINH ='09/02/2003',
@DIACHI ='THAI BINH',@SDT ='1234567890',@MACH ='CH17',
@MACV ='CT',@MANGBC ='NV2',@TRANGTHAI =1,@STYPE ='SELECT'


EXECUTE SP_CRUD_NV_2022 @ID =21,@MA ='1',@TEN ='CONG',@TENDEM ='THANH',
@HO ='NAM',@GIOITINH ='NAM',@NGAYSINH ='09/02/2003',
@DIACHI ='THAI BINH',@SDT ='1234567890',@MACH ='CH17',
@MACV ='CT',@MANGBC ='NV2',@TRANGTHAI =1,@STYPE ='DELETE'

EXECUTE SP_CRUD_NV_2022 @ID =21,@MA ='1',@TEN =N'Tiến',@TENDEM ='THANH',
@HO ='NAM',@GIOITINH ='NAM',@NGAYSINH ='09/02/2003',
@DIACHI ='THAI BINH',@SDT ='1234567890',@MACH ='CH17',
@MACV ='CT',@MANGBC ='NV2',@TRANGTHAI =1,@STYPE ='UPDATE'


/*
 3.5 Trigger trong SQL
❑Trigger là một dạng đặc biệt của thủ tục lưu trữ  (store procedure), được thực thi một cách tự động khi có sự thay đổi dữ liệu (do tác động của
câu lệnh INSERT, UPDATE, DELETE) trên một bảng nào đó.
❑Không thể gọi thực hiện trực tiếp Trigger bằng lệnh EXECUTE.
❑Trigger là một stored procedure không có tham số.
❑Trigger được lưu trữ trong DB Server và thường hay được dùng để kiểm tra ràng buộc toàn vẹn dữ liệu
-- Các Trigger DDL và DML có cách sử dụng khác nhau và được	thực thi với các sự kiện cơ sở dữ liệu khác nhau.
   1. Trigger DDL
		- Các Trigger DDL thực thi các thủ tục lưu trữ trên câu lệnh CREATE, ALTER va DROP
		- Các Trigger DDL được sử dụng để kiểm tra và kiểm soát các hoạt động của cơ sở dữ liệu
		- Các Trigger DDL chỉ hoạt động sau khi bảng hoặc khung nhìn được sửa đổi
		- Các Trigger DDL được định nghĩa ở mức cơ sở liệu hoặc máy chủ
   2. Trigger DML
		- Các Trigger DML thực thi trên các câu lệnh INSERT, UPDATE và DELETE
		- Các Trigger DML được sử dụng để thực thi các quy tắc NGHIỆP VỤ khi dữ liệu được sửa đổi trong bảng hoặc khung hình
		- Các Trigger DML thực thi trong hoặc sau khi dữ liệu được sửa đổi.
		- Các Triigger DML được định nghĩa ở mức cơ sở dữ liệu	 
*/

/* TRIGGER DML 
❑Các trigger DML được thực thi khi sự kiện DML	xảy ra trong các bảng hoặc VIEW.
❑Trigger DML này bao gồm các câu lệnh INSERT, UPDATE và DELETE.
❑Các trigger DML gồm ba loại chính:Trigger	INSERT, Trigger UPDATE, Trigger DELETE Sinh ra Các bảng Inserted và Deleted
❖Các trigger DML sử dụng hai loại bảng đặc biệt để sửa đổi dữ liệu trong cơ sở dữ liệu.
❖Các bảng tạm thời lưu trữ dữ liệu ban đầu cũng như	 dữ liệu đã sửa đổi. Những bảng này gồm Inserted và	Deleted.
❖Bảng Inserted:chứa bản sao các bản ghi được sửa đổi với hoạt động INSERT và UPDATE trên bảng trigger.
Hoạt động INSERT và UPDATE sẽ tiến hành chèn các bản ghi mới vào bảng Inserted và bảng trigger.
❖Bảng Deleted:chứa bản sao của các bản ghi được sửa đổi với hoạt động DELETE và UPDATE trên bảng trigger
*/

 /*
 Trigger INSERT
❖Trigger INSERT được thực thi khi một bản ghi mới được chèn vào bảng
❖Trigger INSERT đảm bảo rằng giá trị đang được nhập	phù hợp với các ràng buộc được định nghĩa trên bảng đó.
❖Bảng Inserted và Deleted về khía cạnh vật lý chúng không tồn tại trong cơ sở dữ liệu
❖Trigger INSERT được tạo ra bằng cách sử dụng từ  khóa INSERT trong câu lệnh CREATE TRIGGER và ALTER TRIGGER.
 
CREATE TRIGGER Tên_trigger ON Tên_Bảng
FOR {DELETE, INSERT, UPDATE}
AS
BEGIN
	Câu lệnh T-SQL
END 
❖tên_trigger: chỉ ra tên của trigger do người dùng tự đặt
❖Tên bảng: chỉ ra bảng mà trên đó trigger DML được tạo ra
(bảng trigger).
❖FOR : hoạt động thao tác dữ liệu.
❖Câu lệnh sql: chỉ ra các câu lệnh SQL được thực thi trong
trigger DML
 */
 GO
 ALTER TRIGGER TG_INSERT_NhanVien_CheckSDT ON NhanVien
 FOR INSERT
 AS
 BEGIN
	IF ((SELECT LEN(SDT) FROM inserted) < 10 OR (SELECT LEN(SDT) FROM inserted) >11)
	BEGIN
		PRINT N'Số điện thoại tối thiểu phải từ 10 đến 11 số ở VN'
		ROLLBACK TRANSACTION
	END
 END

 INSERT INTO NhanVien
VALUES ('NV9993',N'Dũng',N'Anh',N'Nguyễn','Nam','1991-05-03',N'152 Hàng Buồm Hà Nội','123',1,17,null,1)

-- Viết 1 câu UPDATE sdt nhỏ hơn 10 và lớn 11 xem có update đc không?
UPDATE NhanVien
SET Sdt = '123'
WHERE Ma = 'NV1'


/*
 Trigger UPDATE
❖Trigger UPDATE sao chép bản ghi gốc vào bảng  Deleted và bản ghi mới vào bảng Inserted
❖Nếu các giá trị mới là hợp lệ thì bản ghi từ bảng Inserted sẽ được sao chép vào bảng dữ liệu
❖Trigger UPDATE được tạo ra bằng cách sử dụng từ khóa UPDATE trong câu lệnh CREATE TRIGGER và ALTER TRIGGER.
❖Cú pháp tương tự trigger insert
 
CREATE TRIGGER Tên_trigger ON Tên_Bảng
FOR {DELETE, INSERT, UPDATE}
AS
BEGIN
	Câu lệnh TSQL
END  
 */
  GO
 CREATE TRIGGER TG_UPDATE_NhanVien_CheckSDT ON NhanVien
 FOR UPDATE
 AS
 BEGIN
	IF ((SELECT LEN(SDT) FROM inserted) < 10 OR (SELECT LEN(SDT) FROM inserted) >11)
	BEGIN
		PRINT N'Số điện thoại tối thiểu phải từ 10 đến 11 số ở VN'
		ROLLBACK TRANSACTION
	END
 END

UPDATE NhanVien
SET Sdt = '12345678111111'
WHERE Ma = 'NV1'

-- Ví dụ về Delete
GO
 ALTER TRIGGER TG_DELETE_HoaDonByID ON HoaDon
 INSTEAD OF DELETE
 AS
 BEGIN
	DELETE FROM HoaDonChiTiet WHERE IdHoaDon IN(SELECT Id FROM deleted)
	DELETE FROM HoaDon WHERE Id IN (SELECT Id FROM deleted)
 END


DELETE FROM HoaDon WHERE Id = 1

--Cấm xóa nhân viên có chức vụ là giám đốc và trưởng phòng
GO
 ALTER TRIGGER TG_DELETE_CamXoaNVCoChucVu ON NhanVien
 INSTEAD OF DELETE
 AS
 BEGIN
	IF (SELECT COUNT(Id) FROM deleted WHERE IdCV IN (SELECT Id FROM ChucVu WHERE Ma = 'GD' OR Ma = 'TP')) > 0
	BEGIN
		PRINT N'Bạn không thể thể xóa nhân viên là trưởng phòng hoặc giám đốc'
		ROLLBACK TRANSACTION
	END
 END

 DELETE FROM NhanVien WHERE Id = 27

/*
HÀM NGƯỜI DÙNG TỰ ĐỊNH NGHĨA
❑Là một đối tượng CSDL chứa các câu lệnh SQL,
được biên dịch sẵn và lưu trữ trong CSDL.
❑Thực hiện một hành động như các tính toán
phức tạp và trả về kết quả là một giá trị.
❑Giá trị trả về có thể là:
	❖Giá trị vô hướng
	❖Một bảng
SO SÁNH HÀM VỚI THỦ TỤC
❑Tương tự như Stored Procedure
❖Là một đối tượng CSDL chứa các câu lệnh SQL, được
biên dịch sẵn và lưu trữ trong CSDL.
❑Khác với Stored Procedure
➢Các hàm luôn phải trả về một giá trị, sử dụng câu lệnh
RETURN
➢Hàm không có tham số đầu ra
➢Không được chứa các câu lệnh INSERT, UPDATE, DELETE
một bảng hoặc view đang tồn tại trong CSDL
➢Có thể tạo bảng, bảng tạm, biến bảng và thực hiện các câu
lệnh INSERT, UPDATE, DELETE trên các bảng, bảng tạm,
biến bảng vừa tạo trong thân hàm
Hàm giá trị vô hướng: Trả về giá trị đơn của mọi kiểu dữ liệu
Hàm giá trị bảng đơn giản: Trả về bảng, là kết quả của một câu SELECT đơn.
Hàm giá trị bảng nhiều câu lệnh: Trả về bảng là kêt quả của nhiều câu lệnh
*/
-- Ví dụ 1: VIết 1 hàm tính tuổi người dùng khi họ nhập năm sinh
GO 
CREATE FUNCTION F_TinhTuoi(@Ns INT)
RETURNS INT -- PHẢI SỬ DỤNG RETURNS để định nghĩa kiểu dữ liệu trả về
AS
BEGIN
	RETURN YEAR(GETDATE()) - @Ns
END
-- Sử dụng từ khóa dbo. gọi hàm là bắt buộc
PRINT dbo.F_TinhTuoi(2000)

SELECT Ma,dbo.F_TinhTuoi(YEAR(NgaySinh)) AS N'Tuổi' FROM NhanVien

-- Ví dụ 2: Viết 1 Hàm đếm số lượng nhân viên theo giới tính
GO
ALTER FUNCTION F_DemSLNV_GioiTinh(@GT NVARCHAR(10))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(GioiTinh) FROM NhanVien WHERE GioiTinh = @GT)
END

PRINT dbo.F_DemSLNV_GioiTinh(N'NỮ')
-- Bài tập: Viết 1 Hàm đếm số lượng nhân viên theo giới tính và theo từng cửa hàng.

GO
ALTER FUNCTION F_DemSLNV_GioiTinh_CH(@GT NVARCHAR(10),@MaCH VARCHAR(20))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(GioiTinh) FROM NhanVien 
			JOIN CuaHang ON CuaHang.Id = NhanVien.IdCH
			WHERE GioiTinh = @GT AND CuaHang.Ma = @MaCH)
END

-- Hàm trả về 1 bảng
GO
CREATE FUNCTION F_GETALLNhanVien()
RETURNS TABLE
AS RETURN SELECT * FROM NhanVien

-- Khi hàm trả về 1 bảng thì sẽ dụng câu lệnh SELECT để gọi hàm và có thể sử dụng dbo. hoặc không
SELECT * FROM F_GETALLNhanVien()

-- Hàm trả về giá trị là đa câu lệnh
GO
CREATE FUNCTION F_GetTableNhanVien_GT(@GT NVARCHAR(10))
RETURNS @TBL_NhanVien TABLE(TenNV NVARCHAR(30),MaNV VARCHAR(20),GT NVARCHAR(10))
AS
BEGIN
	IF(@GT IS NULL)
	BEGIN
		INSERT INTO @TBL_NhanVien
		SELECT Ten,Ma,GioiTinh FROM NhanVien
	END
	ELSE
	BEGIN
		INSERT INTO @TBL_NhanVien
		SELECT Ten,Ma,GioiTinh FROM NhanVien WHERE  GioiTinh = @GT
	END
	RETURN
END

SELECT * FROM F_GetTableNhanVien_GT(NULL)
SELECT * FROM F_GetTableNhanVien_GT(N'Nữ')
/* Xóa/Sửa Nội Dung của một hàm chỉ cần dùng DROP/ALTER*/


/*
VIEW là gì:
❑Che dấu và bảo mật dữ liệu
❖Không cho phép người dùng xem toàn bộ dữ liệu
chứa trong các bảng.
❖Bằng cách chỉ định các cột trong View, các dữ liệu
quan trọng chứa trong một số cột của bảng có thể
được che dấu
❑Hiển thị dữ liệu một cách tùy biến
❖Với mỗi người dùng khác nhau, có thể tạo các View
khác nhau phù hợp với nhu cầu xem thông tin của
từng người dùng
❑Lưu trữ câu lệnh truy vấn phức tạp và thường
xuyên sử dụng.
❑Thực thi nhanh hơn các câu lệnh truy vấn do đã
được biên dịch sẵn
❑Đảm bảo tính toàn vẹn dữ liệu
❖Khi sử dụng View để cập nhật dữ liệu trong các bảng
cơ sở, SQL Server sẽ tự động kiểm tra các ràng buộc
toàn vẹn trên các bản
❑Tên view không được trùng với tên bảng hoặc
view đã tồn tại
❑Câu lệnh SELECT tạo VIEW
❖Không được chứa mệnh đề INTO, hoặc ORDER BY trừ
khi chứa từ khóa TOP
❑Đặt tên cột
❖Cột chứa giá trị được tính toán từ nhiều cột khác phải
được đặt tên
❖Nếu cột không được đặt tên, tên cột sẽ được mặc
định giống tên cột của bảng cơ sở
*/

GO
ALTER VIEW View_DSNVNu1
AS
SELECT * FROM NhanVien WHERE GioiTinh = N'Nữ'

-- Muốn xem được view thì hãy làm việc như làm việc với bảng
SELECT * FROM View_DSNVNu1 WHERE IdCH = 1

/*PHÂN LOẠI VIEW
❑VIEW chỉ đọc (read-only view)
❖View này chỉ dùng để xem dữ liệu
❑VIEW có thể cập nhật (updatable view)
❖Xem dữ liệu
❖Có thể sử dụng câu lệnh INSERT, UPDATE, DELETE để
cập nhật dữ liệu trong các bảng cơ sở qua View
Yêu cầu: Câu lệnh select không được chứa
	❖Mệnh đề DISTINCT hoặc TOP
	❖Một hàm kết tập (Aggregate function)
	❖Một giá trị được tính toán
	❖Mệnh đề GROUP BY và HAVING
	❖Toán tử UNION
	❖Nếu câu lệnh tạo View vi phạm một trong số điều
	kiện trên. VIEW được tạo ra là VIEW chỉ đọc
*/
-- GIẢI BÀI TẬP 
-- View 1:
/*
View 1: Tạo ra 1 View báo cáo doanh số sản phẩm bao gồm các cột thông tin sau để báo cáo cho giám đốc 
của đại lý sấp xếp giảm dần theo Số lượng đã bán:
[Mã Sản Phẩm] [Tên Sản Phẩm] [Mã Dòng Sản phẩm] [Tên Dòng Sản phẩm] [Số Lượng Tồn Kho] [Số Lượng Đã Bán]
 [Số tiền lãi] 
*/