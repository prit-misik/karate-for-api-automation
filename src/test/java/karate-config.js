function fn() {
    var env = karate.env; // get system property 'karate.env'
    karate.log('karate.env system property was:', env);

    if (!env) {
        env = 'preprod-uk';
        karate.log('============================ Env is dev-uk by default ============================');
    }

    if (env == 'dev-uk') {
        'dev-uk';
        karate.log('============================ Env is dev-uk ============================');
        var config = {
            env: env,
            propertiesMap: '',
            credentials: {},
            regionSpcfcDataFile: 'uk_dev_data.json',
            services_endpoint: 'https://services-uk.dev.servertech.co.uk/',
            auth0_url: 'https://server-dev-uk.eu.auth0.com'
        }

    } else if (env == 'staging-uk') {
        'staging-uk';
        karate.log('============================ Env is staging-uk ============================');
        var config = {
            env: env,
            services_endpoint: 'https://services-uk.staging.servertech.co.uk/',
            appointments_endpoint: 'https://app-uk.staging.servertech.co.uk',

        }
    } else if (env == 'preprod-uk') {
        'preprod-uk';
        karate.log('============================ Env is preprod-uk ============================');
        var config = {
            env: env,
            services_endpoint: 'https://services-uk.preprod.servertech.co.uk/',
            auth0_url: 'https://auth.my.preprod.servertech.co.uk'
        }
    }
   }

    var result = karate.callSingle('classpath:memberDomain/features/commonFeatures/credentials.feature', config);
    config.allCredentials = result.credentials;
    return config;
}