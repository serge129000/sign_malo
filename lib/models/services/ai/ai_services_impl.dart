import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:signe_malo/models/objects/exception.dart';
import 'package:signe_malo/models/services/ai/ai_services.dart';

class AiServicesImpl implements AiServices {
  @override
  Future<Map<String, dynamic>> getGeminiResponse(
      {required List<Map<String, dynamic>> posesJson}) async {
    try {
      await dotenv.load(fileName: '.env');
      final model = GenerativeModel(
        model: 'gemini-1.5-pro-001',
        apiKey: dotenv.env['GEMINI_KEY']!,
      );
      final prompt =
          '''Vous êtes une IA spécialisée dans la traduction pointilleuse des langages des signes à partir de données de pose corporelle. Je vais vous fournir des données sous la forme d'un JSON contenant des points de pose représentant les coordonnées des articulations du corps. Votre tâche est de décoder ces points de pose pour en déduire le ou les mots ou phrases correspondants dans le langage des signes spécifié. Veuillez retourner la réponse sous forme de JSON avec les résultats de la traduction, leur probabilité associée et des informations supplémentaires sur la traduction.

**Voici un exemple de données d'entrée et le format attendu pour la réponse :**

**Données d'entrée :**
{
  "pose_points": [
    {
      "type": "LEFT_EYE",
      "x": 0.5,
      "y": 0.6,
      "z": 0.7
    },
    {
      "type": "RIGHT_EYE",
      "x": 0.4,
      "y": 0.5,
      "z": 0.6
    }
    // Ajoutez d'autres points de pose ici
  ],
}

**Format de réponse attendu :**
{
  "result": [
    {
      "result": "String",  // Mot ou phrase traduit
      "probability": int,  // Probabilité de la traduction (entre 0 et 100)
      "additional_info": {  // Informations supplémentaires sur la traduction
        "sign_details": {  // Détails sur le signe
          "sign_name": "String",  // Nom du signe
          "sign_description": "String",  // Description du signe
          "sign_variations": ["String", "String"],  // Variantes du signe
          "sign_origin": "String"  // Origine du signe (ex : LSF, ASL)
        },
        "context_clues": ["String", "String"],  // Indices contextuels (ex : expressions faciales, mouvements du corps)
        "translation_notes": "String"  // Notes sur la traduction (ex : incertitudes, ambiguïtés)
      }
    }
  ]
}

**Merci de traiter les données suivantes et de n'envoyer que le JSON sans plus aucun texte et sans préciser que c'est du JSON. ceci: $posesJson**

**Données à traiter : $posesJson** et eviter de retourner une reponse vide merci le langage utilise le LSF
''';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (response.text == null) {
        throw AiException(unexceptedValue: response.text);
      } else {
        try {
          String goodFormat =
              response.text!.replaceAll(RegExp(r'```json\n*'), "");
          goodFormat = goodFormat.replaceAll(RegExp(r'```'), '');
          final data = jsonDecode(goodFormat) as Map<String, dynamic>;
          if (data.isEmpty) {
            throw AiException(unexceptedValue: "Aucune pose detecte");
          }
          return data;
        } catch (e) {
          throw AiException(unexceptedValue: response.text);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
