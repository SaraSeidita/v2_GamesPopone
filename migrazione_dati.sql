-- migrazione dati dalla vecchia tabella (nuova conoscenza)

USE GamesPopone_V2;
GO

SET IDENTITY_INSERT dbo.Auth ON;
INSERT INTO dbo.Auth (ID, Username, Pw, ProfilePicUrl, Ruolo, VersioneToken)
SELECT ID, Username, Pw, ProfilePicUrl, Ruolo, VersioneToken
FROM GamesPopone.dbo.Auth;
SET IDENTITY_INSERT dbo.Auth OFF;
GO

SET IDENTITY_INSERT dbo.Videogiochi ON;
INSERT INTO dbo.Videogiochi (ID, Titolo, Genere, AnnoUscita, Trama, ImmagineUrl, Nascosto, DataInserimento)
SELECT ID, Titolo, Genere, AnnoUscita, Trama, ImmagineUrl,
       ISNULL(Nascosto, 0), ISNULL(DataInserimento, SYSDATETIME())
FROM GamesPopone.dbo.Videogiochi;
SET IDENTITY_INSERT dbo.Videogiochi OFF;
GO

INSERT INTO dbo.VideogiocoXUtente (VideogiocoID, UtenteID, Piattaforma, AnnoGiocata, Recensione, Nascosto)
SELECT v.ID,
       ISNULL(v.UtenteID, (SELECT TOP 1 ID FROM dbo.Auth WHERE Ruolo = 'Admin' ORDER BY ID)),
       ISNULL(NULLIF(TRIM(v.Piattaforma), ''), 'Non specificata'),
       v.AnnoGiocata, v.Recensione, ISNULL(v.Nascosto, 0)
FROM GamesPopone.dbo.Videogiochi v;
GO