-- ------------------------------------------------------------------------------- 
--   Génération des triggers de la base 
--   de données : PPE_Karate
--   (7/1/2015 12:20:54)
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

     /* Supprimer les occurrences correspondantes de la table CHOISIR. */
     delete CHOISIR
     from CHOISIR,deleted
     where
          CHOISIR.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
     /* Interdire la suppression d'une occurrence de ENTRAINEUR s'il existe des */
     /* occurrences correspondantes de la table CLUB. */
     if exists
          (
          select * from deleted,CLUB
          where
               CLUB.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          )
     begin
          select @errno  = 30001,
                @errmsg = 'Impossible de supprimer ENTRAINEUR car CLUB existe.'
          goto error
     end
     /* Supprimer les occurrences correspondantes de la table JUGER. */
     delete JUGER
     from JUGER,deleted
     where
          JUGER.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO

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
     /* occurrences correspondantes de la table CHOISIR. */
     if
          update(ENT_NUMLIPRO)
     begin
          if @numrows = 1
          begin
               select @insENT_NUMLIPRO = inserted.ENT_NUMLIPRO
               from inserted
               update CHOISIR
               set
                    CHOISIR.ENT_NUMLIPRO = @insENT_NUMLIPRO
               from CHOISIR,inserted,deleted
               where
                    CHOISIR.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de ENTRAINEUR sur CHOISIR.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de ENTRAINEUR sur les */
     /* occurrences correspondantes de la table CLUB. */
     if
          update(ENT_NUMLIPRO)
     begin
          if @numrows = 1
          begin
               select @insENT_NUMLIPRO = inserted.ENT_NUMLIPRO
               from inserted
               update CLUB
               set
                    CLUB.ENT_NUMLIPRO = @insENT_NUMLIPRO
               from CLUB,inserted,deleted
               where
                    CLUB.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de ENTRAINEUR sur CLUB.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de ENTRAINEUR sur les */
     /* occurrences correspondantes de la table JUGER. */
     if
          update(ENT_NUMLIPRO)
     begin
          if @numrows = 1
          begin
               select @insENT_NUMLIPRO = inserted.ENT_NUMLIPRO
               from inserted
               update JUGER
               set
                    JUGER.ENT_NUMLIPRO = @insENT_NUMLIPRO
               from JUGER,inserted,deleted
               where
                    JUGER.ENT_NUMLIPRO = deleted.ENT_NUMLIPRO
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de ENTRAINEUR sur JUGER.'
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
               select @insPERS_ID = inserted.PERS_ID
               from inserted
               update LICENCIE
               set
                    LICENCIE.PERS_ID = @insPERS_ID
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
               select @insPERS_ID = inserted.PERS_ID
               from inserted
               update ENTRAINEUR
               set
                    ENTRAINEUR.PERS_ID = @insPERS_ID
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
--   Table : LICENCIE
-- ------------------------------------------------------------------------------- 

create trigger TD_LICENCIE
on LICENCIE for delete as
begin
     declare  @errno   int,
                @errmsg  varchar(255)

     /* Supprimer les occurrences correspondantes de la table PARTICIPER. */
     delete PARTICIPER
     from PARTICIPER,deleted
     where
          PARTICIPER.LI_NUMLI = deleted.LI_NUMLI
     /* Supprimer les occurrences correspondantes de la table JUGER. */
     delete JUGER
     from JUGER,deleted
     where
          JUGER.LI_NUMLI = deleted.LI_NUMLI

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
     /* occurrences correspondantes de la table PARTICIPER. */
     if
          update(LI_NUMLI)
     begin
          if @numrows = 1
          begin
               select @insLI_NUMLI = inserted.LI_NUMLI
               from inserted
               update PARTICIPER
               set
                    PARTICIPER.LI_NUMLI = @insLI_NUMLI
               from PARTICIPER,inserted,deleted
               where
                    PARTICIPER.LI_NUMLI = deleted.LI_NUMLI
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de LICENCIE sur PARTICIPER.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de LICENCIE sur les */
     /* occurrences correspondantes de la table JUGER. */
     if
          update(LI_NUMLI)
     begin
          if @numrows = 1
          begin
               select @insLI_NUMLI = inserted.LI_NUMLI
               from inserted
               update JUGER
               set
                    JUGER.LI_NUMLI = @insLI_NUMLI
               from JUGER,inserted,deleted
               where
                    JUGER.LI_NUMLI = deleted.LI_NUMLI
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de LICENCIE sur JUGER.'
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
               select @insKATA_NUM = inserted.KATA_NUM
               from inserted
               update COMPETITION
               set
                    COMPETITION.KATA_NUM = @insKATA_NUM
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

     /* Supprimer les occurrences correspondantes de la table PARTICIPER. */
     delete PARTICIPER
     from PARTICIPER,deleted
     where
          PARTICIPER.COMPET_DATE = deleted.COMPET_DATE and
          PARTICIPER.COMPET_NUM = deleted.COMPET_NUM
     /* Supprimer les occurrences correspondantes de la table CHOISIR. */
     delete CHOISIR
     from CHOISIR,deleted
     where
          CHOISIR.COMPET_DATE = deleted.COMPET_DATE and
          CHOISIR.COMPET_NUM = deleted.COMPET_NUM
     /* Supprimer les occurrences correspondantes de la table JUGER. */
     delete JUGER
     from JUGER,deleted
     where
          JUGER.COMPET_DATE = deleted.COMPET_DATE and
          JUGER.COMPET_NUM = deleted.COMPET_NUM

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
     /* occurrences correspondantes de la table PARTICIPER. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          if @numrows = 1
          begin
               select @insCOMPET_DATE = inserted.COMPET_DATE, 
                         @insCOMPET_NUM = inserted.COMPET_NUM
               from inserted
               update PARTICIPER
               set
                    PARTICIPER.COMPET_DATE = @insCOMPET_DATE,
                    PARTICIPER.COMPET_NUM = @insCOMPET_NUM
               from PARTICIPER,inserted,deleted
               where
                    PARTICIPER.COMPET_DATE = deleted.COMPET_DATE and
                    PARTICIPER.COMPET_NUM = deleted.COMPET_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de COMPETITION sur PARTICIPER.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de COMPETITION sur les */
     /* occurrences correspondantes de la table CHOISIR. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          if @numrows = 1
          begin
               select @insCOMPET_DATE = inserted.COMPET_DATE, 
                         @insCOMPET_NUM = inserted.COMPET_NUM
               from inserted
               update CHOISIR
               set
                    CHOISIR.COMPET_DATE = @insCOMPET_DATE,
                    CHOISIR.COMPET_NUM = @insCOMPET_NUM
               from CHOISIR,inserted,deleted
               where
                    CHOISIR.COMPET_DATE = deleted.COMPET_DATE and
                    CHOISIR.COMPET_NUM = deleted.COMPET_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de COMPETITION sur CHOISIR.'
               raiserror(@errno, @errmsg,16,1)
          end
     end
     /* Répercuter la modification de la clé primaire de COMPETITION sur les */
     /* occurrences correspondantes de la table JUGER. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          if @numrows = 1
          begin
               select @insCOMPET_DATE = inserted.COMPET_DATE, 
                         @insCOMPET_NUM = inserted.COMPET_NUM
               from inserted
               update JUGER
               set
                    JUGER.COMPET_DATE = @insCOMPET_DATE,
                    JUGER.COMPET_NUM = @insCOMPET_NUM
               from JUGER,inserted,deleted
               where
                    JUGER.COMPET_DATE = deleted.COMPET_DATE and
                    JUGER.COMPET_NUM = deleted.COMPET_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de COMPETITION sur JUGER.'
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
     /* Supprimer les occurrences correspondantes de la table CHOISIR. */
     delete CHOISIR
     from CHOISIR,deleted
     where
          CHOISIR.CLUB_NUM = deleted.CLUB_NUM

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

     /* Interdire la modification de la clé étrangère de la table CLUB s'il */
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
                  @errmsg = 'Impossible de mettre à jour CLUB car ENTRAINEUR n''existe pas.'
               goto error
         end
     end
     /* Répercuter la modification de la clé primaire de CLUB sur les */
     /* occurrences correspondantes de la table LICENCIE. */
     if
          update(CLUB_NUM)
     begin
          if @numrows = 1
          begin
               select @insCLUB_NUM = inserted.CLUB_NUM
               from inserted
               update LICENCIE
               set
                    LICENCIE.CLUB_NUM = @insCLUB_NUM
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
               select @insCLUB_NUM = inserted.CLUB_NUM
               from inserted
               update COMPETITION
               set
                    COMPETITION.CLUB_NUM = @insCLUB_NUM
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
     /* occurrences correspondantes de la table CHOISIR. */
     if
          update(CLUB_NUM)
     begin
          if @numrows = 1
          begin
               select @insCLUB_NUM = inserted.CLUB_NUM
               from inserted
               update CHOISIR
               set
                    CHOISIR.CLUB_NUM = @insCLUB_NUM
               from CHOISIR,inserted,deleted
               where
                    CHOISIR.CLUB_NUM = deleted.CLUB_NUM
          end
          else
          begin
               select @errno = 30006,
                  @errmsg = 'Impossible de répercuter la modification de CLUB sur CHOISIR.'
               raiserror(@errno, @errmsg,16,1)
          end
     end

     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_CLUB
on CLUB 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de CLUB s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer CLUB car ENTRAINEUR n''existe pas.'
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
--   Table : PARTICIPER
-- ------------------------------------------------------------------------------- 

create trigger TU_PARTICIPER
on PARTICIPER
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
     /* COMPETITION. */


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_PARTICIPER
on PARTICIPER 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de PARTICIPER s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer PARTICIPER car LICENCIE n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de PARTICIPER s'il n'existe pas */
     /* d'occurrence correspondante dans la table COMPETITION. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,COMPETITION
          where
               inserted.COMPET_DATE = COMPETITION.COMPET_DATE AND
               inserted.COMPET_NUM = COMPETITION.COMPET_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer PARTICIPER car COMPETITION n''existe pas.'
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
--   Table : CHOISIR
-- ------------------------------------------------------------------------------- 

create trigger TU_CHOISIR
on CHOISIR
for update as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la modification de la clé étrangère référençant la table */
     /* CLUB. */

     /* Interdire la modification de la clé étrangère référençant la table */
     /* ENTRAINEUR. */

     /* Interdire la modification de la clé étrangère référençant la table */
     /* COMPETITION. */


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_CHOISIR
on CHOISIR 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de CHOISIR s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer CHOISIR car CLUB n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de CHOISIR s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer CHOISIR car ENTRAINEUR n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de CHOISIR s'il n'existe pas */
     /* d'occurrence correspondante dans la table COMPETITION. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,COMPETITION
          where
               inserted.COMPET_DATE = COMPETITION.COMPET_DATE AND
               inserted.COMPET_NUM = COMPETITION.COMPET_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer CHOISIR car COMPETITION n''existe pas.'
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
--   Table : JUGER
-- ------------------------------------------------------------------------------- 

create trigger TU_JUGER
on JUGER
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
     /* COMPETITION. */

     /* Interdire la modification de la clé étrangère référençant la table */
     /* ENTRAINEUR. */


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


create trigger TI_JUGER
on JUGER 
for insert as
begin
     declare  @numrows int,
                @nullcnt int,
                @validcnt int,
                @errno   int,
                @errmsg  varchar(255)

     select @numrows = @@rowcount

     /* Interdire la création d'une occurrence de JUGER s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer JUGER car LICENCIE n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de JUGER s'il n'existe pas */
     /* d'occurrence correspondante dans la table COMPETITION. */
     if
          update(COMPET_DATE) or
          update(COMPET_NUM)
     begin
          select @nullcnt = 0
          select @validcnt = count(*)
          from inserted,COMPETITION
          where
               inserted.COMPET_DATE = COMPETITION.COMPET_DATE AND
               inserted.COMPET_NUM = COMPETITION.COMPET_NUM
               
          if @validcnt + @nullcnt != @numrows
          begin
               select @errno  = 30002,
                  @errmsg = 'Impossible d''insérer JUGER car COMPETITION n''existe pas.'
               goto error
          end
     end
     /* Interdire la création d'une occurrence de JUGER s'il n'existe pas */
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
                  @errmsg = 'Impossible d''insérer JUGER car ENTRAINEUR n''existe pas.'
               goto error
          end
     end


     return
     error:
         raiserror(@errno, @errmsg,16,1)
         rollback transaction
end
go


