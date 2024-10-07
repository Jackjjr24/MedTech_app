import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  final picker = ImagePicker();
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false; // Add this line to manage loading state

  final Map<String, String> diseaseDetails = {
    "Acne-and-Rosacea": '''
     Acne and Rosacea: Remedies and Prevention
    
    While both acne and rosacea can cause redness and bumps on the skin, they have different underlying causes and treatments.

    * Acne: Primarily caused by clogged pores and bacterial overgrowth.
    * Rosacea: A chronic skin condition that causes redness and visible blood vessels.

    **General Tips for Both Conditions**
    
    * Gentle Skincare: Avoid harsh scrubs or soaps that can irritate the skin.
    * Moisturize: Keep your skin hydrated to prevent dryness and irritation.
    * Avoid Triggers: Identify and avoid triggers like spicy foods, alcohol, and extreme temperatures.
    * Sun Protection: Wear sunscreen daily to protect your skin from harmful UV rays.

    **Specific Remedies and Prevention**
    
    Acne
    * Over-the-Counter Medications: Products containing benzoyl peroxide or salicylic acid can help unclog pores and reduce inflammation.
    * Prescription Medications: For severe acne, a dermatologist may prescribe antibiotics, retinoids, or hormonal treatments.
    * Lifestyle Changes: A balanced diet, regular exercise, and stress management can also help.

    Rosacea
    * Topical Medications: Azelaic acid, metronidazole, and ivermectin can help reduce redness and bumps.
    * Laser Therapy: For more severe cases, laser treatments can target visible blood vessels.
    * Lifestyle Modifications: Avoiding triggers, managing stress, and protecting your skin from the sun can help prevent flare-ups.

    **Consulting a Dermatologist**
    
    If you're experiencing persistent or severe acne or rosacea, it's important to consult a dermatologist. They can provide a proper diagnosis and recommend the most effective treatment plan for your specific needs.
    ''',
    "Atopic Dermatitis": '''
    Atopic Dermatitis: Remedies and Prevention
    
    Atopic dermatitis, also known as eczema, is a chronic skin condition that causes itchy, red, and dry patches. It often affects people with a family history of allergies.

    **General Tips**
    
    * Moisturize Regularly: Keep your skin hydrated with a gentle moisturizer.
    * Identify Triggers: Pinpoint factors that worsen your symptoms, such as allergens, irritants, or stress.
    * Avoid Irritants: Minimize contact with harsh soaps, detergents, and fabrics.
    * Cool Baths: Short, lukewarm baths or showers can help soothe itchy skin.
    * Avoid Scratching: Scratching can worsen inflammation.

    **Specific Remedies and Prevention**
    
    * Topical Medications: Corticosteroid creams or ointments can help reduce inflammation. Topical calcineurin inhibitors may also be effective.
    * Emollients: These moisturizers can help restore the skin's barrier function.
    * Antihistamines: Oral antihistamines can alleviate itching.
    * Light Therapy: Narrowband UVB phototherapy can be helpful for severe cases.
    * Lifestyle Changes: Managing stress, avoiding allergens, and getting enough sleep can help.

    **Consulting a Dermatologist**
    
    If you're struggling with atopic dermatitis, it's important to consult a dermatologist. They can provide a proper diagnosis and recommend the most effective treatment plan for your specific needs.
    ''',
    "Bullous-Disease": '''
    Bullous Pemphigoid: Remedies and Prevention

    Bullous pemphigoid is an autoimmune skin disease characterized by blistering. It's caused by an immune system malfunction that attacks the skin's basement membrane.

    **Treatment**
    
    * Corticosteroids: Oral corticosteroids are often the first line of treatment to suppress the immune system and reduce inflammation.
    * Topical Corticosteroids: High-potency topical corticosteroids can be used to treat localized blisters.
    * Immunosuppressants: For severe cases, immunosuppressant medications may be necessary to control the immune system.
    * Rituximab: This monoclonal antibody can be effective for treating bullous pemphigoid in some cases.

    **Prevention**
    
    While there's no way to prevent bullous pemphigoid, early diagnosis and treatment can help minimize discomfort and complications.

    **Important Note:** Bullous pemphigoid is a serious condition that requires medical attention. If you suspect you have or are experiencing symptoms of bullous pemphigoid, it's crucial to consult a dermatologist for proper diagnosis and treatment.
    ''',
    "Cellulitis-Impetigo": '''
    Cellulitis and Impetigo: Remedies and Prevention

    * Cellulitis: A bacterial infection of the skin and underlying tissues, often characterized by redness, warmth, and tenderness.
    * Impetigo: A contagious bacterial skin infection, usually caused by Staphylococcus aureus or Streptococcus pyogenes, often appearing as red sores that may rupture and crust over.

    **Treatment**
    
    Both cellulitis and impetigo require prompt medical attention to prevent complications. Treatment typically involves:
    * Antibiotics: Oral or intravenous antibiotics are prescribed to treat the bacterial infection.
    * Warm Compresses: Applying warm compresses can help soothe the affected area and promote drainage.
    * Skin Care: Keeping the affected area clean and dry is important.

    **Prevention**
    
    * Hygiene: Wash your hands frequently, especially after touching wounds or sick individuals.
    * Wound Care: Clean and cover any cuts or scrapes promptly.
    * Avoid Sharing: Don't share personal items like towels or clothing.
    * Strengthen Immune System: A healthy diet, regular exercise, and adequate sleep can help boost your immune system.

    **Important Note:** If you suspect you have cellulitis or impetigo, it's crucial to seek medical attention. Delaying treatment can increase the risk of complications, such as spreading the infection or developing systemic illness.
    ''',
    "Exanthems-and-Drug-Eruptions": '''
     Exanthems and Drug Eruptions: Remedies and Prevention

    * Exanthems: Rash-like skin eruptions, often caused by viral infections. Examples include measles, rubella, and chickenpox.
    * Drug Eruptions: Skin reactions caused by medications. They can vary in severity from mild rashes to life-threatening conditions.

    **Treatment**
    
    The treatment for exanthems and drug eruptions depends on the underlying cause. For exanthems, treatment is often supportive, focusing on managing symptoms like fever and discomfort. For drug eruptions, the offending medication is usually discontinued.

    **Prevention**
    
    * Vaccines: Vaccines are available for many exanthems, such as measles, mumps, rubella, and chickenpox.
    * Medication Awareness: If you have a history of allergies or adverse reactions to medications, inform your doctor before starting new treatments.
    * Monitor for Reactions: Be aware of early signs of drug eruptions, such as rashes, itching, or swelling.

    **Important Note:** Exanthems and drug eruptions can be serious conditions. If you suspect you have or are experiencing symptoms of either, it's crucial to seek medical attention for proper diagnosis and treatment.
    ''',
    "Light-Diseases-and-Disorders-of-Pigmentation": '''
     Light Diseases and Disorders of Pigmentation: Remedies and Prevention

    Light diseases and disorders of pigmentation affect melanin, the pigment that gives skin, hair, and eyes their color. These conditions can cause variations in skin tone, hair color, and even vision problems.

    **Common Conditions**
    
    * Vitiligo: A condition that causes loss of pigment, resulting in white patches on the skin.
    * Albinism: A genetic condition that reduces or prevents the production of melanin, leading to pale skin, hair, and eyes.
    * Melasma: A condition that causes brown patches on the skin, often triggered by hormonal changes or sun exposure.
    * Freckles: Small, flat, brown spots on the skin caused by increased melanin production in response to sun exposure.
    * Ephelides: Similar to freckles but often larger and darker.

    **Treatment and Prevention**
    
    The treatment for light diseases and disorders of pigmentation varies depending on the specific condition and its severity. Some options include:
    * Topical Medications: Creams or ointments can help improve pigmentation in conditions like vitiligo.
    * Laser Therapy: Laser treatments can target areas of hyperpigmentation (dark spots) or hypopigmentation (light spots).
    * Light Therapy: Exposure to ultraviolet light can be beneficial for certain conditions, such as vitiligo.
    * Sunscreen: Protecting your skin from sun exposure is essential for preventing or worsening pigmentation disorders.
    * Camouflage: Makeup and other cosmetic products can help conceal skin discoloration.

    **Important Note:** If you're experiencing changes in your skin pigmentation, it's important to consult a dermatologist for proper diagnosis and treatment. Early intervention can often improve outcomes.
    ''',
    "Lupus-and-other-Connective-Tissue-diseases": '''
     Lupus and Connective Tissue Diseases: Remedies and Prevention

    Connective tissue diseases, including lupus, affect the tissues that support and protect organs and structures in the body. These conditions can cause inflammation and damage to various parts of the body.

    **Lupus (Systemic Lupus Erythematosus)**
    
    * Symptoms: Common symptoms include fatigue, joint pain, skin rashes, and fever. Lupus can affect multiple organs, including the skin, joints, kidneys, and heart.

    **Treatment and Prevention**
    
    * Medications: Treatment often includes anti-inflammatory drugs, immunosuppressants, and corticosteroids to manage symptoms and reduce inflammation.
    * Lifestyle Changes: A healthy diet, regular exercise, and stress management can help improve overall well-being and manage symptoms.
    * Sun Protection: Wearing sunscreen and avoiding excessive sun exposure can help prevent lupus flare-ups.

    **Important Note:** Lupus and other connective tissue diseases are complex conditions that require ongoing medical care. If you suspect you have a connective tissue disease, it's important to consult a healthcare professional for accurate diagnosis and treatment.
    ''',
    "Melanoma-Skin-Cancer-Nevi-and-Moles": '''
     Melanoma, Skin Cancer, Nevi, and Moles: Prevention and Detection

    Melanoma is the most serious type of skin cancer, arising from melanocytes, the cells that produce melanin. It can be deadly if not detected and treated early.

    **Risk Factors**
    
    * Excessive Sun Exposure: Unprotected exposure to ultraviolet (UV) radiation from the sun or tanning beds.
    * Family History: A family history of melanoma or other skin cancers.
    * Skin Type: Fair skin with freckles or a history of sunburn.
    * Age: The risk of melanoma increases with age.
    * Certain Moles: Moles with irregular borders, multiple colors, or a diameter larger than 6 millimeters (about the size of a pencil eraser).

    **Prevention**
    
    * Sun Protection: Wear broad-spectrum sunscreen with an SPF of 30 or higher daily, even on cloudy days.
    * Limit Sun Exposure: Avoid prolonged sun exposure, especially during peak hours (10 AM to 4 PM).
    * Protective Clothing: Wear hats, sunglasses, and long-sleeved clothing when outdoors.
    * Regular Self-Exams: Conduct monthly skin exams to check for any changes in existing moles or the appearance of new ones.
    * Professional Check-ups: See a dermatologist for regular skin exams, especially if you have risk factors.

    **ABCDE Rule for Identifying Melanoma**
    
    * Asymmetry: One half of the mole doesn't match the other.
    * Border: The border is irregular, notched, or blurred.
    * Color: The color is uneven or includes multiple colors.
    * Diameter: The diameter is larger than 6 millimeters (about the size of a pencil eraser).
    * Evolving: The mole is changing in size, shape, or color.

    **Treatment**
    
    The treatment for melanoma depends on the stage of the cancer. Options may include surgery, chemotherapy, radiation therapy, immunotherapy, or a combination of these treatments.

    **Important Note:** If you notice any changes in a mole or discover a new one that meets the ABCDE criteria, consult a dermatologist immediately. Early detection and treatment are crucial for improving outcomes.
    ''',
    "Monkeypox": '''
     Monkeypox: Prevention and Treatment

    Monkeypox is a viral illness that can cause a rash, fever, and swollen lymph nodes. It is transmitted through close contact with an infected person or animal.

    **Symptoms**
    
    * Fever
    * Headache
    * Muscle aches
    * Backache
    * Swollen lymph nodes
    * Fatigue
    * Rash

    **Transmission**
    
    Monkeypox is primarily spread through:
    * Close contact with an infected person's rash or sores
    * Contact with contaminated materials, such as bedding or clothing
    * Respiratory droplets during prolonged face-to-face contact

    **Prevention**
    
    * Vaccination: The Jynneos vaccine is available to prevent monkeypox.
    * Safe Sex Practices: Use condoms and limit the number of sexual partners.
    * Avoid Contact: Avoid close contact with people who have a rash or other symptoms of monkeypox.
    * Good Hygiene: Practice good hand hygiene and avoid touching your face.

    **Treatment**
    
    While there's no specific treatment for monkeypox, supportive care can help manage symptoms. In severe cases, antiviral medications may be used.

    **Important Note:** If you experience symptoms of monkeypox, it's crucial to seek medical attention immediately. Early diagnosis and treatment can help prevent complications.
    ''',
    "Poison-Ivy-and-other-Contact-Dermatitis": '''
     Poison Ivy, Poison Oak, and Poison Sumac: Prevention and Treatment

Contact dermatitis is a skin irritation caused by coming into contact with an allergen or irritant. Poison ivy, poison oak, and poison sumac are common causes of contact dermatitis.

**Prevention**

* Avoid Contact: Learn to recognize these plants and avoid touching them.
* Protective Gear: Wear long sleeves, pants, gloves, and boots when in areas where these plants grow.
* Wash Immediately: If you come into contact with these plants, wash your skin with soap and water as soon as possible.

**Treatment**

* Over-the-Counter Medications: Calamine lotion or hydrocortisone cream can help relieve itching and inflammation.
* Cool Compresses: Applying cool compresses can soothe the affected area.
* Oral Antihistamines: If itching is severe, oral antihistamines may be helpful.
* Prescription Medications: In severe cases, a doctor may prescribe stronger topical or oral medications.

**Important Note:** If you develop a severe reaction or have difficulty breathing, seek medical attention immediately.
''',
    "Psoriasis-Lichen-Planus-and-related-diseases": '''
     Psoriasis, Lichen Planus, and Related Diseases: Remedies and Prevention

* Psoriasis: A chronic autoimmune condition that causes skin cells to grow too quickly, resulting in thick, scaly patches.
* Lichen Planus: A skin condition that causes itchy, flat-topped, purplish bumps.

**Other Related Conditions**

* Psoriatic Arthritis: A form of arthritis that affects people with psoriasis.
* Lichen Planus Mucosae: A type of lichen planus that affects the mucous membranes of the mouth, genitals, or anus.

**Treatment**

The treatment for psoriasis and lichen planus depends on the severity of the condition. Some options include:

* Topical Medications: Corticosteroid creams or ointments can help reduce inflammation and itching.
* Light Therapy: Exposure to ultraviolet light can help improve symptoms.
* Systemic Medications: For severe cases, oral or injected medications may be necessary.
* Lifestyle Changes: Managing stress, avoiding triggers, and maintaining a healthy lifestyle can help improve symptoms.

**Prevention**

While there's no way to prevent psoriasis or lichen planus, early diagnosis and treatment can help minimize their impact.

**Important Note:** If you're experiencing symptoms of psoriasis or lichen planus, it's important to consult a dermatologist for proper diagnosis and treatment.

''',
    "Scabies-Lyme-Disease-and-other-Infestations-and-Bites": '''
     Scabies, Lyme Disease, and Other Infestations and Bites: Prevention and Treatment

* Scabies: A contagious skin infestation caused by mites that burrow into the skin.
* Lyme Disease: A tick-borne bacterial infection that can cause a rash, fatigue, and other symptoms.

**Other Infestations and Bites**

* Bedbugs: Small, wingless insects that feed on human blood and can cause itchy bites.
* Fleas: Small, wingless insects that can also cause itchy bites and transmit diseases like the plague.
* Ticks: Parasitic arachnids that can transmit diseases like Lyme disease and Rocky Mountain spotted fever.

**Prevention**

* Insect Repellent: Use insect repellent containing DEET, picaridin, or other effective ingredients.
* Clothing: Wear long-sleeved shirts, pants, and socks when in areas with ticks or other insects.
* Regular Checks: Check yourself for ticks after spending time outdoors.
* Pet Care: Treat pets for fleas and ticks.
* Home Maintenance: Keep your home clean and free of clutter to prevent bedbugs and other pests.

**Treatment**

* Scabies: Topical scabicides can kill the mites and their eggs.
* Lyme Disease: Antibiotics are used to treat Lyme disease.
* Bedbugs: Professional pest control services can help eliminate bedbugs.
* Fleas: Treating pets and cleaning the environment can help control fleas.
* Tick Bites: Remove ticks promptly and monitor for symptoms of tick-borne diseases.

**Important Note:** If you suspect you have scabies, Lyme disease, or another infestation, seek medical attention for proper diagnosis and treatment.
''',
    "Seborrheic-Keratoses-and-other-Benign-Tumors": '''

     Seborrheic Keratoses and Other Benign Tumors

Seborrheic keratoses are common, benign skin growths that often appear as raised, wart-like lesions. They are typically harmless and do not pose a health risk.

**Other Benign Tumors**

* Moles (Nevi): Common skin growths that can be flat or raised, and vary in color from brown to black. Most moles are benign, but some can develop into melanoma.
* Skin Tags: Small, fleshy growths that often appear on the neck, armpits, or groin.
* Cysts: Fluid-filled sacs that can form under the skin.
* Lipomas: Benign fatty tumors that often appear as soft, movable lumps under the skin.

**Treatment**

While most benign tumors do not require treatment, some people may opt to have them removed for cosmetic reasons or if they are causing discomfort. Treatment options may include:

* Observation: Many benign tumors do not require treatment and can be monitored for changes.
* Excision: Surgical removal is often the preferred method for treating benign tumors.
* Cauterization: This involves burning off the tumor with a hot instrument.
* Freezing: Cryotherapy involves freezing the tumor with liquid nitrogen.

**Prevention**

While there is no way to prevent the development of benign tumors, protecting your skin from excessive sun exposure can help reduce the risk of certain skin cancers.

**Important Note:** If you notice any changes in a mole or other skin growth, it's important to consult a dermatologist for evaluation. While most benign tumors are harmless, some can be precancerous or cancerous.
''',
    "Tinea Ringworm Candidiasis and other Fungal Infections": '''
     Tinea, Ringworm, Candidiasis, and Other Fungal Infections: Remedies and Prevention

Fungal infections can affect various parts of the body, including the skin, nails, scalp, and mucous membranes. Common fungal infections include:

* Tinea (Ringworm): A fungal infection that causes a circular or oval rash.
* Candidiasis (Yeast Infection): A fungal infection caused by Candida yeast.
* Athlete's Foot: A fungal infection of the feet.
* Jock Itch: A fungal infection of the groin.

**Treatment**

The treatment for fungal infections depends on the specific type and location of the infection. Common treatments include:

* Topical Antifungal Medications: Creams, ointments, or powders can be used to treat skin and nail fungal infections.
* Oral Antifungal Medications: For more severe or widespread infections, oral medications may be necessary.
* Home Remedies: Over-the-counter antifungal remedies and good hygiene practices can help manage mild fungal infections.

**Prevention**

* Good Hygiene: Practice good personal hygiene, including washing your body regularly and keeping your nails clean.
* Dry Areas: Keep affected areas dry, especially between toes and fingers.
* Avoid Sharing: Don't share personal items like towels, clothing, or razors.
* Wear Breathable Clothing: Choose clothing made from breathable fabrics to help prevent moisture buildup.

**Important Note:** If you have a persistent or recurring fungal infection, it's important to consult a healthcare provider for proper diagnosis and treatment.
''',
    "Urticaria-Hives": '''
     Urticaria (Hives): Remedies and Prevention

Urticaria, commonly known as hives, is a skin condition characterized by raised, itchy welts that can appear suddenly and disappear within 24 hours. They are often caused by an allergic reaction to a trigger, but can also be triggered by non-allergic factors.

**Common Triggers**

* Allergens: Foods (e.g., nuts, shellfish), medications, insect stings, and environmental factors (e.g., pollen, dust mites)
* Non-Allergic Factors: Stress, heat, cold, exercise, and certain medical conditions

**Treatment**

* Antihistamines: Over-the-counter or prescription antihistamines can help relieve itching and reduce the size of hives.
* Cool Compresses: Applying cool compresses can help soothe the affected area.
* Avoid Triggers: Identifying and avoiding triggers can prevent future outbreaks.
* Prescription Medications: In severe cases, prescription medications may be necessary to control hives.

**Prevention**

* Identify Triggers: Keep a diary to track potential triggers and avoid them.
* Manage Stress: Stress can contribute to hives. Practice stress-reduction techniques like meditation or yoga.
* Avoid Irritants: Minimize exposure to irritants like harsh soaps or detergents.

**Important Note:** If you experience hives that are severe, persistent, or accompanied by other symptoms like difficulty breathing or swelling of the face or throat, seek medical attention immediately.

''',
    "Vascular-Tumors": '''
     Vascular Tumors: Types and Treatment

Vascular tumors are abnormal growths that develop from blood vessels. They can occur in various parts of the body and vary in size and severity.

**Types of Vascular Tumors**

    * Hemangiomas: Benign tumors composed of blood vessels.
    * Infantile hemangioma: Rapidly growing, bright red birthmark that often disappears on its own.
    * Capillary hemangioma: Flat, red birthmark that may fade over time.
    * Cavernous hemangioma: Deep, blue or purple birthmark that may be associated with bleeding or pain.
    * Angiosarcoma: A rare, malignant tumor of blood vessels.
    * Lymphangiomas: Benign tumors composed of lymphatic vessels.

**Treatment**

The treatment for vascular tumors depends on the type, size, location, and symptoms. Some may not require treatment, while others may benefit from the following:

* Observation: Many infantile hemangiomas and capillary hemangiomas resolve on their own without treatment.
* Laser Therapy: Can be used to treat hemangiomas, especially those that are disfiguring or causing symptoms.
* Surgery: May be necessary to remove large or symptomatic vascular tumors.
* Sclerotherapy: Involves injecting a substance into the tumor to cause it to shrink.
* Chemotherapy or Radiation Therapy: May be used to treat malignant vascular tumors, such as angiosarcoma.

**Important Note:** If you notice a new or unusual growth on your skin or body, it's important to consult a healthcare provider for evaluation. Early diagnosis and treatment can improve outcomes.
''',
    "Vasculitis": '''
     Vasculitis: Types and Treatment

Vasculitis is a group of inflammatory conditions that affect the blood vessels. It can cause inflammation, narrowing, or blockage of blood vessels, leading to a variety of symptoms depending on the affected organs.

**Types of Vasculitis**

There are many different types of vasculitis, each with its own unique characteristics and symptoms. Some common types include:

* Giant Cell Arteritis (GCA): Affects large arteries, often causing headaches, jaw pain, and vision problems.
* Polyarteritis Nodosa (PAN): Affects medium-sized arteries, leading to abdominal pain, fever, and nerve damage.
* Behçet's Disease: A systemic inflammatory condition that can cause vasculitis, as well as mouth sores, skin rashes, and eye inflammation.
* Granulomatosis with Polyangiitis: Affects small and medium-sized arteries, leading to respiratory symptoms, kidney problems, and nerve damage.

**Symptoms**

The symptoms of vasculitis can vary depending on the affected blood vessels. Common symptoms may include:

* Fever
* Fatigue
* Weight loss
* Joint pain
* Skin rashes
* Shortness of breath
* Chest pain
* Abdominal pain
* Vision problems
* Nerve damage

**Treatment**

The treatment for vasculitis depends on the specific type and severity of the condition. It may involve:

* Corticosteroids: To reduce inflammation and suppress the immune system.
* Immunosuppressants: To help control the immune system.
* Blood Thinners: To prevent blood clots.
* Pain Medications: To manage pain and discomfort.

**Important Note:** If you experience symptoms of vasculitis, it's important to seek medical attention immediately. Early diagnosis and treatment can help prevent complications and improve outcomes.
''',
    "Warts Molluscum and other Viral Infections": '''
     Warts, Molluscum, and Other Viral Infections: Remedies and Prevention

* Warts: Benign growths on the skin caused by the human papillomavirus (HPV).
* Molluscum Contagiosum: A viral infection that causes small, raised bumps on the skin.

**Other Viral Infections**

* Herpes Simplex Virus (HSV): Can cause painful sores on the genitals, mouth, or rectum.
* Human Papillomavirus (HPV): Can cause genital warts or cervical cancer.
* Molluscum Contagiosum: A viral infection that causes small, raised bumps on the skin.
* Verruca Plantaris (Plantar Warts): Warts that appear on the soles of the feet.

**Treatment**

The treatment for warts and molluscum depends on the type, size, and location of the infection. Some options include:

* Over-the-Counter Medications: Salicylic acid or cryotherapy kits can be used to treat common warts.
* Prescription Medications: For persistent or severe warts, a doctor may prescribe stronger medications or procedures.
* Laser Therapy: Can be used to remove warts and molluscum.
* Curettage and Cauterization: A procedure to scrape off the wart and then cauterize the base to prevent recurrence.

**Prevention**

* Good Hygiene: Practice good hand hygiene and avoid sharing personal items.
* Avoid Touching: Avoid touching warts or molluscum to prevent spreading the infection.
* Strengthen Immune System: A healthy lifestyle can help boost your immune system and fight off infections.

**Important Note:** If you have concerns about warts, molluscum, or other viral infections, consult a healthcare provider for proper diagnosis and treatment.
'''

    // Add other diseases and their details here
  };

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        // Add the user's image to the messages
        messages.add({
          'type': 'userImage',
          'content': _image,
        });
        _isLoading = true; // Show loading indicator
      });
      _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://classify.roboflow.com/skin-disease-classification-opfbn/2?api_key=S5ML7UF6I5p9JHqQkppq"),
    );

    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = json.decode(responseBody);
      final predictions = decodedResponse['predictions'] as Map<String, dynamic>;

      if (predictions.isNotEmpty) {
        String highestConfidenceDisease = '';
        double highestConfidence = 0.0;

        predictions.forEach((disease, data) {
          if (data['confidence'] > highestConfidence) {
            highestConfidence = data['confidence'];
            highestConfidenceDisease = disease;
          }
        });

        setState(() {
          // Add AI response (disease name) to the messages
          messages.add({
            'type': 'aiText',
            'content': highestConfidenceDisease,
          });

          // Add corresponding disease details if available
          if (diseaseDetails.containsKey(highestConfidenceDisease)) {
            messages.add({
              'type': 'aiText',
              'content': diseaseDetails[highestConfidenceDisease]!,
            });
          }
          _isLoading = false; // Hide loading indicator
        });
      } else {
        setState(() {
          messages.add({
            'type': 'aiText',
            'content': 'No predictions found',
          });
          _isLoading = false; // Hide loading indicator
        });
      }
    } else {
      setState(() {
        messages.add({
          'type': 'aiText',
          'content': 'Failed to upload image',
        });
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Disease'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.teal, // Set the color of the app bar
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.png'),
                // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Center text widget
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  // Adjust padding to avoid overlap
                  child: Text(
                    'Upload the image of your affected skin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message['type'] == 'userImage') {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.file(
                                  message['content'],
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/logo.png'), // Adding the logo
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message['content'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                // Button to choose from gallery only
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _getImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.photo_library),
                          SizedBox(width: 5),
                          Text('Choose from Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}