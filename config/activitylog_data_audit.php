<?php

return [
    // log_name => transformer
    'users' => \App\Transformers\Polymorphics\ActivityLog\UserTransformer::class,

    // Exemplo para adicionar mais tarde:
    // 'crm_contacts' => \App\ActivityAudit\Transformers\CrmContactTransformer::class,
    // 'crm_business' => \App\ActivityAudit\Transformers\CrmBusinessTransformer::class,
];
