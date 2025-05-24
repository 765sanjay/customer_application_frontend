import 'package:flutter/material.dart';
import 'dart:io'; // For handling file images
import 'package:image_picker/image_picker.dart'; // For picking images from gallery

class ServicesSection extends StatefulWidget {
  final List<Map<String, dynamic>> services;
  final bool isBusiness;

  ServicesSection({required this.services, required this.isBusiness});

  @override
  _ServicesSectionState createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  final List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    final popularServices = widget.services.where((service) => service['Sflag'] == 1).toList();
    final otherServices = widget.services.where((service) => service['Sflag'] != 1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHorizontalSection('Popular Services', popularServices),
        SizedBox(height: 20),
        _buildHorizontalSection('Our Services', otherServices),
      ],
    );
  }

  void _addService() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.services.add({
          'ImageUrl': pickedFile.path,
          'ServiceName': 'New Service',
          'ServiceDesc': 'Describe this service',
          'ServiceCost': '0',
          'Sflag': 0,
        });
      });
    }
  }

  void _editService(Map<String, dynamic> service) {
    TextEditingController nameController = TextEditingController(text: service['ServiceName']);
    TextEditingController descriptionController = TextEditingController(text: service['ServiceDesc']);
    TextEditingController priceController = TextEditingController(text: service['ServiceCost']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                service['ServiceName'] = nameController.text;
                service['ServiceDesc'] = descriptionController.text;
                service['ServiceCost'] = priceController.text;
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection(String title, List<Map<String, dynamic>> serviceList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (title == 'Our Services' && widget.isBusiness)
              IconButton(
                onPressed: _addService,
                icon: Icon(Icons.add_circle),
              ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final service = serviceList[index];
              return _buildServiceCard(service);
            },
          ),
        ),
      ],
    );
  }

  Widget _threeDotMenu(BuildContext context, Map<String, dynamic> service) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Edit') {
          _editService(service);
        } else if (value == 'Delete') {
          setState(() {
            widget.services.remove(service);
          });
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: 'Edit',
            child: Text('Edit'),
          ),
          PopupMenuItem<String>(
            value: 'Delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: service['ImageUrl'].startsWith('http')
                      ? Image.network(
                          service['ImageUrl'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(service['ImageUrl']),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    service['ServiceName'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    service['ServiceDesc'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          service['ServiceCost'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow,
                          ),
                          child: Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.isBusiness && (service['Sflag'] == 0))
              Positioned(
                top: 8,
                right: 8,
                child: _threeDotMenu(context, service),
              ),
          ],
        ),
      ),
    );
  }
}
