/*
 ----------------------------------------------------------------------------
             Génération d'une base de données pour
                        SQL Server 7.x
                       (7/1/2015 12:20:22)
 ----------------------------------------------------------------------------
     Nom de la base : ScriptKarate
     Projet : Accueil Win'Design version 14
     Auteur : GROSCLAUDE
     Date de dernière modification : 7/1/2015 12:20:17
 ----------------------------------------------------------------------------
*/

/* -----------------------------------------------------------------------------
      OUVERTURE DE LA BASE ScriptKarate
----------------------------------------------------------------------------- */

create database ScriptKarate
go

use ScriptKarate
go



/* -----------------------------------------------------------------------------
      TABLE : ENTRAINEUR
----------------------------------------------------------------------------- */

create table ENTRAINEUR
  (
     ENT_NUMLIPRO int  not null  ,
     PERS_ID int  not null  ,
     ENT_NIVCAPACITE int  null 
      DEFAULT 5      CHECK (ENT_NIVCAPACITE in (1, 2, 3, 4, 5)),
     PERS_NOM varchar(20)  null  ,
     PERS_PRENOM varchar(20)  null  ,
     PERS_DATENAISSANCE datetime  null  ,
     PERS_ADRUE varchar(64)  null  ,
     PERS_ADVILLE varchar(25)  null  ,
     PERS_ADCP int  null  
     ,
     constraint PK_ENTRAINEUR primary key (ENT_NUMLIPRO)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : PERSONNE
----------------------------------------------------------------------------- */

create table PERSONNE
  (
     PERS_ID int  not null  ,
     PERS_NOM varchar(20)  null  ,
     PERS_PRENOM varchar(20)  null  ,
     PERS_DATENAISSANCE datetime  null  ,
     PERS_ADRUE varchar(64)  null  ,
     PERS_ADVILLE varchar(25)  null  ,
     PERS_ADCP int  null  
     ,
     constraint PK_PERSONNE primary key (PERS_ID)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : LICENCIE
----------------------------------------------------------------------------- */

create table LICENCIE
  (
     LI_NUMLI int  not null  ,
     CLUB_NUM int  not null  ,
     PERS_ID int  not null  ,
     LI_LINKPHOTO varchar(128)  null  ,
     PERS_NOM varchar(20)  null  ,
     PERS_PRENOM varchar(20)  null  ,
     PERS_DATENAISSANCE datetime  null  ,
     PERS_ADRUE varchar(64)  null  ,
     PERS_ADVILLE varchar(25)  null  ,
     PERS_ADCP int  null  
     ,
     constraint PK_LICENCIE primary key (LI_NUMLI)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : KATA
----------------------------------------------------------------------------- */

create table KATA
  (
     KATA_NUM int  not null  ,
     KATA_NOM varchar(64)  null  
     ,
     constraint PK_KATA primary key (KATA_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : COMPETITION
----------------------------------------------------------------------------- */

create table COMPETITION
  (
     COMPET_DATE datetime  not null  ,
     COMPET_NUM int  not null  ,
     CLUB_NUM int  not null  ,
     KATA_NUM int  not null  ,
     COMPET_ADRUE varchar(64)  null  ,
     COMPET_ADVILLE varchar(20)  null  ,
     COMPET_ADCP int  null  
     ,
     constraint PK_COMPETITION primary key (COMPET_DATE, COMPET_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : CLUB
----------------------------------------------------------------------------- */

create table CLUB
  (
     CLUB_NUM int  not null  ,
     ENT_NUMLIPRO int  not null  ,
     CLUB_NOM varchar(32)  null  ,
     CLUB_ADVILLE varchar(25)  null  ,
     CLUB_TEL varchar(10)  null  ,
     CLUB_ADRUE varchar(64)  null  ,
     CLUB_ADCP int  null  
     ,
     constraint PK_CLUB primary key (CLUB_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : PARTICIPER
----------------------------------------------------------------------------- */

create table PARTICIPER
  (
     LI_NUMLI int  not null  ,
     COMPET_DATE datetime  not null  ,
     COMPET_NUM int  not null  
     ,
     constraint PK_PARTICIPER primary key (LI_NUMLI, COMPET_DATE, COMPET_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : CHOISIR
----------------------------------------------------------------------------- */

create table CHOISIR
  (
     CLUB_NUM int  not null  ,
     ENT_NUMLIPRO int  not null  ,
     COMPET_DATE datetime  not null  ,
     COMPET_NUM int  not null  
     ,
     constraint PK_CHOISIR primary key (CLUB_NUM, ENT_NUMLIPRO, COMPET_DATE, COMPET_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : JUGER
----------------------------------------------------------------------------- */

create table JUGER
  (
     LI_NUMLI int  not null  ,
     COMPET_DATE datetime  not null  ,
     COMPET_NUM int  not null  ,
     ENT_NUMLIPRO int  not null  ,
     NOTE int  null       CHECK (NOTE <= 10)
     ,
     constraint PK_JUGER primary key (LI_NUMLI, COMPET_DATE, COMPET_NUM, ENT_NUMLIPRO)
  ) 
go



/*
 -----------------------------------------------------------------------------
               FIN DE GENERATION
 -----------------------------------------------------------------------------
*/