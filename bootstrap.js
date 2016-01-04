var pm2 = require('pm2');
var instances = process.env.WEB_CONCURRENCY || -1; 
var maxMemory = process.env.WEB_MEMORY || 512;    

pm2.connect(function() {
    pm2.start({
        script    : 'index.js',
        name      : 'production-app',     // ----> THESE ATTRIBUTES ARE OPTIONAL: 
        exec_mode : 'cluster',            // ----> https://github.com/Unitech/PM2/blob/master/ADVANCED_README.md#schema
        instances : instances,   
        merge_logs: true,                 
        max_memory_restart : maxMemory + 'M',   // Auto restart if process taking more than XXmo
        env: {                            // If needed declare some environment variables
           "NODE_ENV": "production",
           "AWESOME_SERVICE_API_TOKEN": "xxx"
        }
    }, function() {
    
         // Display logs in standard output 
        pm2.launchBus(function(err, bus) {
            console.log('[PM2] Log streaming started');

            bus.on('log:out', function(packet) {
                console.log('[App:%s] %s', packet.process.name, packet.data);
            });
            
            bus.on('log:err', function(packet) {
                console.error('[App:%s][Err] %s', packet.process.name, packet.data);
            });
        });
    });
});