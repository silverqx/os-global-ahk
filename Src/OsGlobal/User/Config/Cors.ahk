ConfigCors := {
    ; Allowed origins for CORS
    AllowedOrigins: ['*'],

    ; Allowed HTTP methods for CORS
    AllowedMethods: ['GET', 'POST', 'PATCH', 'HEAD', 'OPTIONS'],

    ; Allowed HTTP headers for CORS
    AllowedHeaders: ['Content-Type'],

    ; Max age for CORS preflight requests
    MaxAge: 86400 ; 24 hours
}
