#include <sourcemod>
#include <geoip>

#define USE_GEOIP
//#define USE_SXGEO

#pragma semicolon 1

public Plugin myinfo =
{
	name = "[SM] Connect Info",
	author = "AmS SkYIN",
	description = "GeoIP Connect Info plugin",
	version = "1.2",
	url = "https://amsgaming.in"
};

public void OnClientPutInServer(int client)
{
	char sIP[54], sCountry[64], sCity[64], sRegion[64], sLang[3];
	GetClientIP(client, sIP, sizeof(sIP));

	GetLanguageInfo(GetServerLanguage(), sLang, 3);
    
    #if defined USE_GEOIP
	bool bCountryFound = GeoipCountry(sIP, sCountry, sizeof(sCountry));
	bool bRegionFound  = GeoipRegion(sIP, sRegion, sizeof(sRegion));
	bool bCityFound    = GeoipCity(sIP, sCity, sizeof(sCity));
	#endif
	
	#if defined USE_SXGEO
	bool bCountryFound = SxGeoCountry(sIP, sCountry, sizeof(sCountry), sLang);
	bool bRegionFound  = SxGeoRegion(sIP, sRegion, sizeof(sRegion), sLang);
	bool bCityFound    = SxGeoCity(sIP, sCity, sizeof(sCity), sLang);
	#endif
	
	PrintToServer("%s %s %s", sCountry, sRegion, sCity);

	char sBuffer[192];
	
	if (bCountryFound && bCityFound && bRegionFound)
	{
		Format(sBuffer, sizeof(sBuffer), "\x04[AmSGAMiNG]\x03 %N\x01 connected from \x04%s\x03 (%s, %s)", client, sCity, sRegion, sCountry);
	}
	else if (bCountryFound && bRegionFound)
	{
		Format(sBuffer, sizeof(sBuffer), "\x04[AmSGAMiNG]\x03 %N\x01 connected from \x04%s\x03 (%s)", client, sRegion, sCountry);
	}
	else if (bCountryFound)
	{
		Format(sBuffer, sizeof(sBuffer), "\x04[AmSGAMiNG]\x03 %N\x01 connected from \x04%s", client, sCountry);
	}
	else
	{
		// we don't know where you are :(
		Format(sBuffer, sizeof(sBuffer), "\x04[AmSGAMiNG]\x03 %N\x01 connected", client);
	}
	
	PrintToChatAll(sBuffer);
}

