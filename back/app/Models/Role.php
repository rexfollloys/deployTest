<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'canCreate', 'canDelete', 'canComment', 'canGrade'];

    // Relation avec les utilisateurs
    public function users()
    {
        return $this->hasMany(User::class); // Un rôle a plusieurs utilisateurs
    }

}

