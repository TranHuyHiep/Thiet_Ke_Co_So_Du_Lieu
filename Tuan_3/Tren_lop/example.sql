-- Tính tổng số chẵn từ 1 -> 100
declare @t int, @x int
set @t = 0;
set @x = 1;
while(@x <= 100)
	begin
		if((@x % 2) = 0)
			set @t = @t + @x
			set @x = @x + 1
	end
print @t

----

Declare hs cursor for select mahs from DSHS
Open hs
Declare @mahs nvarchar(5), @dtb float
Fetch next from hs into @mahs
While (@@fetch_status = 0)
begin
select @dtb=round((toan*2+ly*2+hoa+ly)/6,2) from diem where
MAHS=@mahs
update dshs set dtbc=@dtb where MAHS=@mahs
Fetch next from hs into @mahs
end
Close hs; Deallocate hs

alter table dshs
add dtbc float null