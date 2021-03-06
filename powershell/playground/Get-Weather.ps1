Function Get-Weather
{
    <#
        .SYNOPSIS
            Get local weather from a webservice
        .DESCRTIPION
            This function was originally written by /\/\o\/\/ I adjusted it to fit my method of
            coding functions up.
        .PARAMETER List
            Returns a list of all countries and cities where weather information is stored.
        .PARAMETER City
            The city where you want to retrieve weather information from.
        .PARAMETER Country
            The country that the city is in.
        .PARAMETER Filter
            Used with the -List switch, will return a filtered list of weather data
        .EXAMPLE
        .NOTES
            The -Filter parameter appears to only filter out by country.
        .LINK
            http://thepowershellguy.com/blogs/posh/archive/2009/05/15/powershell-v2-get-weather-function-using-a-web-service.aspx
    #>
    Param
    (
        [switch]$List,
        $City = 'Topeka, Forbes Field',
        $Country = 'United States',
        $Filter = ''
    )
    Begin
    {
        $WeatherService = New-WebServiceProxy -uri http://www.webservicex.com/globalweather.asmx?WSDL
    }
    
    Process
    {
        if ($List)
        { 
            $Weather = ([xml]$WeatherService.GetCitiesByCountry($Filter)).NewDataSet.table 
            }
        else
        {
            $Weather = ([xml]$WeatherService.GetWeather($City,$Country)).CurrentWeather 
            }
    }
    
    End
    {
        Return $Weather
    }
}
