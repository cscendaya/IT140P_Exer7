package com.example.labexercise7

import kotlinx.serialization.Serializable

@Serializable
data class Record(
    val id: Int = 0,
    val name: String,
    val email: String
)

@Serializable
data class AddRecordRequest(
    val id: String,
    val name: String
)

@Serializable
data class Subject(
    val id: Int,
    val name: String
)

@Serializable
data class AddSubjectRequest(
    val id: Int,
    val name: String
)
