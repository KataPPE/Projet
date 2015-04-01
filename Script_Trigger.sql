-- ------------------------------------------------------------------------------- 
--   Génération des triggers de la base 
--   de données : PPE_Karate
--   (1/4/2015 10:40:21)
-- ------------------------------------------------------------------------------- 

/* -----------------------------------------------------------------------------
      OUVERTURE DE LA BASE PPE_Karate
----------------------------------------------------------------------------- */

use PPE_Karate
go

-- ------------------------------------------------------------------------------- 
--   Table : ENTRAINEUR
-- ------------------------------------------------------------------------------- 

create trigger TD_ENTRAINEUR
on ENTRAINEUR for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Interdire la suppression d'une occurrence de ENTRAINEUR s'il existe des */
     /* occurrences correspondantes de la table JURY. */
     if exists
          (
          select * from deleted,JURY
          where
               JURY.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer ENTRAINEUR car JURY existe.'
          goto error
     end

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_ENTRAINEUR
on ENTRAINEUR
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère de la table ENTRAINEUR s'il */
     /* n'existe pas d'occurrence correspondante de la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour ENTRAINEUR car CLUB n''existe pas.'
               goto error
         end
     end
     /* Interdire la modification de la clé étrangère de la table ENTRAINEUR s'il */
     /* n'existe pas d'occurrence correspondante de la table PERSONNE. */
     if
          update(PERS_ID)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,PERSONNE
          where
               inserted.PERS_ID = PERSONNE.PERS_ID
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour ENTRAINEUR car PERSONNE n''existe pas.'
               goto error
         end
     end
     /* Répercuter la modification de la clé primaire de ENTRAINEUR sur les */
     /* occurrences correspondantes de la table JURY. */
     if
          update(ENT_NUMLIPRO)
     begin
          if @numrows = 1
          begin
               select ENT_NUMLIPRO = inserted.ENT_NUMLIPRO
               from inserted
               update JURY
               set
                    JURY.ENT_NUMLIPRO = inserted.ENT_NUMLIPRO
               from JURY,inserted,deleted
               where
                    JURY.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de ENTRAINEUR sur JURY.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_ENTRAINEUR
on ENTRAINEUR 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de ENTRAINEUR s'il n'existe pas */
     /* d'occurrence correspondante dans la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer ENTRAINEUR car CLUB n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de ENTRAINEUR s'il n'existe pas */
     /* d'occurrence correspondante dans la table PERSONNE. */
     if
          update(PERS_ID)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,PERSONNE
          where
               inserted.PERS_ID = PERSONNE.PERS_ID
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer ENTRAINEUR car PERSONNE n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : PERSONNE
-- ------------------------------------------------------------------------------- 

create trigger TD_PERSONNE
on PERSONNE for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Supprimer les occurrences correspondantes de la table LICENCIE. */
     delete LICENCIE
     from LICENCIE,deleted
     where
          LICENCIE.PERS_ID = deleted.PERS_ID
     /* Supprimer les occurrences correspondantes de la table ENTRAINEUR. */
     delete ENTRAINEUR
     from ENTRAINEUR,deleted
     where
          ENTRAINEUR.PERS_ID = deleted.PERS_ID

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_PERSONNE
on PERSONNE
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Répercuter la modification de la clé primaire de PERSONNE sur les */
     /* occurrences correspondantes de la table LICENCIE. */
     if
          update(PERS_ID)
     begin
          if @numrows = 1
          begin
               select PERS_ID = inserted.PERS_ID
               from inserted
               update LICENCIE
               set
                    LICENCIE.PERS_ID = inserted.PERS_ID
               from LICENCIE,inserted,deleted
               where
                    LICENCIE.PERS_ID = deleted.PERS_ID
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de PERSONNE sur LICENCIE.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de PERSONNE sur les */
     /* occurrences correspondantes de la table ENTRAINEUR. */
     if
          update(PERS_ID)
     begin
          if @numrows = 1
          begin
               select PERS_ID = inserted.PERS_ID
               from inserted
               update ENTRAINEUR
               set
                    ENTRAINEUR.PERS_ID = inserted.PERS_ID
               from ENTRAINEUR,inserted,deleted
               where
                    ENTRAINEUR.PERS_ID = deleted.PERS_ID
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de PERSONNE sur ENTRAINEUR.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : JURY
-- ------------------------------------------------------------------------------- 

create trigger TD_JURY
on JURY for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Supprimer les occurrences correspondantes de la table NOTER. */
     delete NOTER
     from NOTER,deleted
     where
          NOTER.COMPET_NUM = deleted.COMPET_NUM and
          NOTER.JUGE_NUM = deleted.JUGE_NUM

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_JURY
on JURY
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère de la table JURY s'il */
     /* n'existe pas d'occurrence correspondante de la table ENTRAINEUR. */
     if
          update(ENT_NUMLIPRO)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,ENTRAINEUR
          where
               inserted.ENT_NUMLIPRO = ENTRAINEUR.ENT_NUMLIPRO
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour JURY car ENTRAINEUR n''existe pas.'
               goto error
         end
     end
     /* Interdire la modification de la clé étrangère référençant la table */
     /* COMPETITION. */

     /* Répercuter la modification de la clé primaire de JURY sur les */
     /* occurrences correspondantes de la table NOTER. */
     if
          update(COMPET_NUM) or
          update(JUGE_NUM)
     begin
          if @numrows = 1
          begin
               select COMPET_NUM = inserted.COMPET_NUM, 
                         JUGE_NUM = inserted.JUGE_NUM
               from inserted
               update NOTER
               set
                    NOTER.COMPET_NUM = inserted.COMPET_NUM,
                    NOTER.JUGE_NUM = inserted.JUGE_NUM
               from NOTER,inserted,deleted
               where
                    NOTER.COMPET_NUM = deleted.COMPET_NUM and
                    NOTER.JUGE_NUM = deleted.JUGE_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de JURY sur NOTER.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_JURY
on JURY 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de JURY s'il n'existe pas */
     /* d'occurrence correspondante dans la table ENTRAINEUR. */
     if
          update(ENT_NUMLIPRO)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,ENTRAINEUR
          where
               inserted.ENT_NUMLIPRO = ENTRAINEUR.ENT_NUMLIPRO
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer JURY car ENTRAINEUR n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de JURY s'il n'existe pas */
     /* d'occurrence correspondante dans la table COMPETITION. */
     if
          update(COMPET_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,COMPETITION
          where
               inserted.COMPET_NUM = COMPETITION.COMPET_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer JURY car COMPETITION n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : LICENCIE
-- ------------------------------------------------------------------------------- 

create trigger TD_LICENCIE
on LICENCIE for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Supprimer les occurrences correspondantes de la table NOTER. */
     delete NOTER
     from NOTER,deleted
     where
          NOTER.LI_NUMLI = deleted.LI_NUMLI

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_LICENCIE
on LICENCIE
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère de la table LICENCIE s'il */
     /* n'existe pas d'occurrence correspondante de la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour LICENCIE car CLUB n''existe pas.'
               goto error
         end
     end
     /* Interdire la modification de la clé étrangère de la table LICENCIE s'il */
     /* n'existe pas d'occurrence correspondante de la table PERSONNE. */
     if
          update(PERS_ID)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,PERSONNE
          where
               inserted.PERS_ID = PERSONNE.PERS_ID
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour LICENCIE car PERSONNE n''existe pas.'
               goto error
         end
     end
     /* Répercuter la modification de la clé primaire de LICENCIE sur les */
     /* occurrences correspondantes de la table NOTER. */
     if
          update(LI_NUMLI)
     begin
          if @numrows = 1
          begin
               select LI_NUMLI = inserted.LI_NUMLI
               from inserted
               update NOTER
               set
                    NOTER.LI_NUMLI = inserted.LI_NUMLI
               from NOTER,inserted,deleted
               where
                    NOTER.LI_NUMLI = deleted.LI_NUMLI
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de LICENCIE sur NOTER.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_LICENCIE
on LICENCIE 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de LICENCIE s'il n'existe pas */
     /* d'occurrence correspondante dans la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer LICENCIE car CLUB n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de LICENCIE s'il n'existe pas */
     /* d'occurrence correspondante dans la table PERSONNE. */
     if
          update(PERS_ID)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,PERSONNE
          where
               inserted.PERS_ID = PERSONNE.PERS_ID
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer LICENCIE car PERSONNE n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : KATA
-- ------------------------------------------------------------------------------- 

create trigger TD_KATA
on KATA for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Interdire la suppression d'une occurrence de KATA s'il existe des */
     /* occurrences correspondantes de la table COMPETITION. */
     if exists
          (
          select * from deleted,COMPETITION
          where
               COMPETITION.KATA_NUM = deleted.KATA_NUM
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer KATA car COMPETITION existe.'
          goto error
     end

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_KATA
on KATA
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Répercuter la modification de la clé primaire de KATA sur les */
     /* occurrences correspondantes de la table COMPETITION. */
     if
          update(KATA_NUM)
     begin
          if @numrows = 1
          begin
               select KATA_NUM = inserted.KATA_NUM
               from inserted
               update COMPETITION
               set
                    COMPETITION.KATA_NUM = inserted.KATA_NUM
               from COMPETITION,inserted,deleted
               where
                    COMPETITION.KATA_NUM = deleted.KATA_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de KATA sur COMPETITION.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : COMPETITION
-- ------------------------------------------------------------------------------- 

create trigger TD_COMPETITION
on COMPETITION for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Interdire la suppression d'une occurrence de COMPETITION s'il existe des */
     /* occurrences correspondantes de la table JURY. */
     if exists
          (
          select * from deleted,JURY
          where
               JURY.COMPET_NUM = deleted.COMPET_NUM
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer COMPETITION car JURY existe.'
          goto error
     end

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_COMPETITION
on COMPETITION
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère de la table COMPETITION s'il */
     /* n'existe pas d'occurrence correspondante de la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour COMPETITION car CLUB n''existe pas.'
               goto error
         end
     end
     /* Interdire la modification de la clé étrangère de la table COMPETITION s'il */
     /* n'existe pas d'occurrence correspondante de la table KATA. */
     if
          update(KATA_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,KATA
          where
               inserted.KATA_NUM = KATA.KATA_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30007,
                  @errmsg = 'Impossible de mettre à jour COMPETITION car KATA n''existe pas.'
               goto error
         end
     end
     /* Répercuter la modification de la clé primaire de COMPETITION sur les */
     /* occurrences correspondantes de la table JURY. */
     if
          update(COMPET_NUM)
     begin
          if @numrows = 1
          begin
               select COMPET_NUM = inserted.COMPET_NUM
               from inserted
               update JURY
               set
                    JURY.COMPET_NUM = inserted.COMPET_NUM
               from JURY,inserted,deleted
               where
                    JURY.COMPET_NUM = deleted.COMPET_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de COMPETITION sur JURY.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_COMPETITION
on COMPETITION 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de COMPETITION s'il n'existe pas */
     /* d'occurrence correspondante dans la table CLUB. */
     if
          update(CLUB_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,CLUB
          where
               inserted.CLUB_NUM = CLUB.CLUB_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer COMPETITION car CLUB n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de COMPETITION s'il n'existe pas */
     /* d'occurrence correspondante dans la table KATA. */
     if
          update(KATA_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,KATA
          where
               inserted.KATA_NUM = KATA.KATA_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer COMPETITION car KATA n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : CLUB
-- ------------------------------------------------------------------------------- 

create trigger TD_CLUB
on CLUB for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Interdire la suppression d'une occurrence de CLUB s'il existe des */
     /* occurrences correspondantes de la table LICENCIE. */
     if exists
          (
          select * from deleted,LICENCIE
          where
               LICENCIE.CLUB_NUM = deleted.CLUB_NUM
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer CLUB car LICENCIE existe.'
          goto error
     end
     /* Interdire la suppression d'une occurrence de CLUB s'il existe des */
     /* occurrences correspondantes de la table COMPETITION. */
     if exists
          (
          select * from deleted,COMPETITION
          where
               COMPETITION.CLUB_NUM = deleted.CLUB_NUM
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer CLUB car COMPETITION existe.'
          goto error
     end
     /* Interdire la suppression d'une occurrence de CLUB s'il existe des */
     /* occurrences correspondantes de la table ENTRAINEUR. */
     if exists
          (
          select * from deleted,ENTRAINEUR
          where
               ENTRAINEUR.CLUB_NUM = deleted.CLUB_NUM
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer CLUB car ENTRAINEUR existe.'
          goto error
     end

     return
     error:
          raiserror(@errno, @errmsg,16,1)
          rollback transaction
end
go


create trigger TU_CLUB
on CLUB
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Répercuter la modification de la clé primaire de CLUB sur les */
     /* occurrences correspondantes de la table LICENCIE. */
     if
          update(CLUB_NUM)
     begin
          if @numrows = 1
          begin
               select CLUB_NUM = inserted.CLUB_NUM
               from inserted
               update LICENCIE
               set
                    LICENCIE.CLUB_NUM = inserted.CLUB_NUM
               from LICENCIE,inserted,deleted
               where
                    LICENCIE.CLUB_NUM = deleted.CLUB_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de CLUB sur LICENCIE.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de CLUB sur les */
     /* occurrences correspondantes de la table COMPETITION. */
     if
          update(CLUB_NUM)
     begin
          if @numrows = 1
          begin
               select CLUB_NUM = inserted.CLUB_NUM
               from inserted
               update COMPETITION
               set
                    COMPETITION.CLUB_NUM = inserted.CLUB_NUM
               from COMPETITION,inserted,deleted
               where
                    COMPETITION.CLUB_NUM = deleted.CLUB_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de CLUB sur COMPETITION.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de CLUB sur les */
     /* occurrences correspondantes de la table ENTRAINEUR. */
     if
          update(CLUB_NUM)
     begin
          if @numrows = 1
          begin
               select CLUB_NUM = inserted.CLUB_NUM
               from inserted
               update ENTRAINEUR
               set
                    ENTRAINEUR.CLUB_NUM=inserted.CLUB_NUM
               from ENTRAINEUR,inserted,deleted
               where
                    ENTRAINEUR.CLUB_NUM = deleted.CLUB_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de CLUB sur ENTRAINEUR.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


-- ------------------------------------------------------------------------------- 
--   Table : NOTER
-- ------------------------------------------------------------------------------- 

create trigger TU_NOTER
on NOTER
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère référençant la table */
     /* LICENCIE. */

     /* Interdire la modification de la clé étrangère référençant la table */
     /* JURY. */


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_NOTER
on NOTER 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de NOTER s'il n'existe pas */
     /* d'occurrence correspondante dans la table LICENCIE. */
     if
          update(LI_NUMLI)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,LICENCIE
          where
               inserted.LI_NUMLI = LICENCIE.LI_NUMLI
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer NOTER car LICENCIE n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de NOTER s'il n'existe pas */
     /* d'occurrence correspondante dans la table JURY. */
     if
          update(COMPET_NUM) or
          update(JUGE_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,JURY
          where
               inserted.COMPET_NUM = JURY.COMPET_NUM AND
               inserted.JUGE_NUM = JURY.JUGE_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer NOTER car JURY n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


