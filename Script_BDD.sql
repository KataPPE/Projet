/*
 ----------------------------------------------------------------------------
             Génération d'une base de données pour
                        SQL Server 7.x
                       (1/4/2015 10:37:44)
 ----------------------------------------------------------------------------
     Nom de la base : PPE_Karate
     Projet : 
     Auteur : GROSCLAUDE
     Date de dernière modification : 1/4/2015 10:36:59
 ----------------------------------------------------------------------------
*/

/* -----------------------------------------------------------------------------
      OUVERTURE DE LA BASE MLR2
----------------------------------------------------------------------------- */

create database PPE_Karate
go

use PPE_Karate
go



/* -----------------------------------------------------------------------------
      TABLE : ENTRAINEUR
----------------------------------------------------------------------------- */

create table ENTRAINEUR
  (
     ENT_NUMLIPRO int  not null  ,
     CLUB_NUM int  not null  ,
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
      TABLE : JURY
----------------------------------------------------------------------------- */

create table JURY
  (
     COMPET_NUM int  not null  ,
     JUGE_NUM int  not null  ,
     ENT_NUMLIPRO int  not null  
     ,
     constraint PK_JURY primary key (COMPET_NUM, JUGE_NUM)
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
     COMPET_NUM int  not null  ,
     CLUB_NUM int  not null  ,
     KATA_NUM int  not null  ,
     COMPET_DATE datetime  null  ,
     COMPET_ADRUE varchar(64)  null  ,
     COMPET_ADVILLE varchar(20)  null  ,
     COMPET_ADCP int  null  
     ,
     constraint PK_COMPETITION primary key (COMPET_NUM)
  ) 
go



/* -----------------------------------------------------------------------------
      TABLE : CLUB
----------------------------------------------------------------------------- */

create table CLUB
  (
     CLUB_NUM int  not null  ,
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
      TABLE : NOTER
----------------------------------------------------------------------------- */

create table NOTER
  (
     LI_NUMLI int  not null  ,
     COMPET_NUM int  not null  ,
     JUGE_NUM int  not null  ,
     NOTE real  null  
     ,
     constraint PK_NOTER primary key (LI_NUMLI, COMPET_NUM, JUGE_NUM)
  ) 
go



/*
 -----------------------------------------------------------------------------
               FIN DE GENERATION
 -----------------------------------------------------------------------------
*/