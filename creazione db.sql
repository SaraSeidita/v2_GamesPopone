-- 1. creazione db
CREATE DATABASE GamesPopone_V2;
GO
USE GamesPopone_V2;
GO

-- 2. tabella Auth 
CREATE TABLE dbo.Auth (
	ID				INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- ID per identificare la tabella 
	Username		NVARCHAR(50) NOT NULL UNIQUE, -- nome utente not null e unique
	Pw				NVARCHAR(200) NOT NULL, -- pw utente (hash) 
	ProfilePicUrl	NVARCHAR(500) NULL, -- path per l'immagine profilo. Se è null, ci sarà una pic di default
	Ruolo			VARCHAR(20) NOT NULL DEFAULT 'USER', -- Ruolo per distinguere user standard e admin (cioè io)
	VersioneToken	INT DEFAULT 1, -- per l'autenticazione
);
GO

-- 3. tabella Videogiochi 
CREATE TABLE dbo.Videogiochi (
	ID				INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- ID per identificare la tabella 
	Titolo			NVARCHAR(200) NOT NULL, -- titolo del videogioco che non serve avere UNIQUE 
	Genere          NVARCHAR(100) NULL, -- genere del videogioco
    AnnoUscita      INT           NOT NULL, -- anno in cui è uscito
    Trama           NVARCHAR(MAX) NULL, -- trama in breve
    ImmagineUrl     NVARCHAR(500) NULL, -- path per la copertina 
	Nascosto		BIT NOT NULL DEFAULT 0, -- per la 'cancellazione' del record 
	DataInserimento DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

-- 4. Tabella per collegare utente e videogioco 
CREATE TABLE dbo.VideogiocoXUtente (
	ID				INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- ID per identificare la tabella 
	VideogiocoID	INT NOT NULL CONSTRAINT FK_VXU_Videogioco REFERENCES dbo.Videogiochi(ID), -- collegamento con il videogioco
	UtenteID		INT NOT NULL CONSTRAINT FK_VXU_Utente REFERENCES dbo.Auth(ID), -- collegamento con l'utente
	Piattaforma     NVARCHAR(100) NOT NULL, -- un videogioco può essere giocato su più piattaforme
    AnnoGiocata     INT           NULL, -- potrei aver giocato lo stesso gioco in due piattaforme in due momenti diversi
    Recensione      NVARCHAR(MAX) NULL, -- potrei toglierlo o fare semplicemente un breve commento 
    Nascosto        BIT           NOT NULL CONSTRAINT DF_VXU_Nascosto DEFAULT 0, -- stessa logica: per la 'cancellazione' del record la nascondo
    DataInserimento DATETIME2     NOT NULL CONSTRAINT DF_VXU_Data DEFAULT SYSDATETIME(),
    CONSTRAINT UQ_VXU UNIQUE (UtenteID, VideogiocoID, Piattaforma)	
);
GO
