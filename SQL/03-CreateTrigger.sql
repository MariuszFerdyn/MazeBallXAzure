/****** Object:  Trigger [dbo].[dataczas]    Script Date: 3/25/2018 8:17:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[dataczas]
on [dbo].[wyniki]
after insert, update
as
begin
declare @dt datetime = getdate();
update a
set Data = @dt
from [dbo].[wyniki] as a
join inserted as b 
on a.id = b.id; 
end
GO

ALTER TABLE [dbo].[wyniki] ENABLE TRIGGER [dataczas]
GO


