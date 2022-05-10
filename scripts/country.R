countries <- c(
  "Afghanistan", "Åland Islands", "Albania", "Algeria", "American Samoa",
  "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua & Barbuda",
  "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Austria-Hungary",
  "Azerbaijan", "Baden", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
  "Bavaria", "Belarus", "Belgium", "Belize", "Benin", "Bermuda",
  "Bhutan", "Bolivia", "Bosnia & Herzegovina", "Botswana", "Bouvet Island",
  "Brazil", "British Indian Ocean Territory", "British Virgin Islands",
  "Brunei", "Brunswick", "Bulgaria", "Burkina Faso", "Burundi",
  "Cambodia", "Cameroon", "Canada", "Cape Verde", "Caribbean Netherlands",
  "Cayman Islands", "Central African Republic", "Chad", "Chile",
  "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia",
  "Comoros", "Congo - Brazzaville", "Congo - Kinshasa", "Cook Islands",
  "Costa Rica", "Côte d’Ivoire", "Croatia", "Cuba", "Curaçao",
  "Cyprus", "Czechia", "Czechoslovakia", "Denmark", "Djibouti",
  "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador",
  "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia",
  "Falkland Islands", "Faroe Islands", "Fiji", "Finland", "France",
  "French Guiana", "French Polynesia", "French Southern Territories",
  "Gabon", "Gambia", "Georgia", "German Democratic Republic", "Germany",
  "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe",
  "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau", "Guyana",
  "Haiti", "Hamburg", "Hanover", "Heard & McDonald Islands", "Hesse Electoral",
  "Hesse Grand Ducal", "Hesse-Darmstadt", "Hesse-Kassel", "Honduras",
  "Hong Kong SAR China", "Hungary", "Iceland", "India", "Indonesia",
  "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy",
  "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya",
  "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia",
  "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania",
  "Luxembourg", "Macao SAR China", "Madagascar", "Malawi", "Malaysia",
  "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique",
  "Mauritania", "Mauritius", "Mayotte", "Mecklenburg Schwerin",
  "Mexico", "Modena", "Moldova", "Monaco", "Mongolia", "Montenegro",
  "Montserrat", "Morocco", "Mozambique", "Myanmar (Burma)", "Namibia",
  "Nassau", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles",
  "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria",
  "Niue", "Norfolk Island", "North Korea", "North Macedonia", "Northern Mariana Islands",
  "Norway", "Oldenburg", "Oman", "Orange Free State", "Pakistan",
  "Palau", "Palestinian Territories", "Panama", "Papua New Guinea",
  "Paraguay", "Parma", "Peru", "Philippines", "Piedmont-Sardinia",
  "Pitcairn Islands", "Poland", "Portugal", "Prussia", "Puerto Rico",
  "Qatar", "Republic of Vietnam", "Réunion", "Romania", "Russia",
  "Rwanda", "Samoa", "San Marino", "São Tomé & Príncipe", "Sardinia",
  "Saudi Arabia", "Saxe-Weimar-Eisenach", "Saxony", "Senegal",
  "Serbia", "Serbia and Montenegro", "Seychelles", "Sierra Leone",
  "Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands",
  "Somalia", "Somaliland", "South Africa", "South Georgia & South Sandwich Islands",
  "South Korea", "South Sudan", "Spain", "Sri Lanka", "St. Barthélemy",
  "St. Helena", "St. Kitts & Nevis", "St. Lucia", "St. Pierre & Miquelon",
  "St. Vincent & Grenadines", "Sudan", "Suriname", "Svalbard & Jan Mayen",
  "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania",
  "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", "Trinidad & Tobago",
  "Tunisia", "Turkey", "Turkmenistan", "Turks & Caicos Islands",
  "Tuscany", "Tuvalu", "Two Sicilies", "U.S. Virgin Islands", "Uganda",
  "Ukraine", "United Arab Emirates", "United Kingdom", "United Province CA",
  "United States", "United States Minor Outlying Islands (the)",
  "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela",
  "Vietnam", "Wallis & Futuna", "Western Sahara", "Wuerttemburg",
  "Würtemberg", "Yemen",
  "Yugoslavia", "Zambia", "Zanzibar", "Zimbabwe"
)

library(redpul)
dotenv::load_dot_env()
#
# con <- postgres_connector()
#
# submissions <-
#   tbl(con, 'submissions') %>%
#   select(id, title, selftext) %>%
#   filter(
#     str_detect(str_to_lower(paste0(title, selftext)), 'russia')
#   )

query <- map(
  str_to_lower(countries),
  function(x) glue("select *, '{x}' as country from submissions where title ilike '%{x}%' or selftext ilike '%{x}%'")
) %>%
  paste0(collapse = " union ")


dbGetQuery(con, query)
