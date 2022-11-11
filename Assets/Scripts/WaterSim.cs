using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]


public class WaterSim : MonoBehaviour
{
    private MeshFilter meshFilter;
    private Vector3[] vertices = null;
    private Vector3[] tmpVertices = null;

    private void Awake()
    {
        meshFilter = GetComponent<MeshFilter>();
        vertices = meshFilter.mesh.vertices;            // resultant wave mesh 
        tmpVertices = meshFilter.mesh.vertices;         // copy of the original mesh to use in the calculations
    }

    private void Update()
    {
        for (int i = 0; i < vertices.Length; i++)
        {
            vertices[i] = Waves.instance.GetWaveHeight(1.0f, 1.0f, 3.0f, 0.5f, tmpVertices[i]);
        }

        meshFilter.mesh.vertices = vertices;
        meshFilter.mesh.RecalculateNormals();
    }
}
