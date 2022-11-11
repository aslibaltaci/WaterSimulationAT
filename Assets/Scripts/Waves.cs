using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waves : MonoBehaviour
{
    public static Waves instance;

    private void Awake()
    {
        // makes sure there is only ever one instance

        if (instance == null)
        {
            instance = this;
        }
        else if (instance != this)
        {
            Debug.Log("Instance exists");
            Destroy(this);
        }
    }

    public Vector3 GetWaveHeight(float dirX, float dirZ, float waveLength, float amplitude, Vector3 point)
    {
        Vector3 newPoint = point;

        float k = 2.0f * 3.141592f / waveLength;
        float c = 0.5f * Mathf.Sqrt(9.8f / k);
        float f = k * (newPoint.x * dirX + newPoint.z * dirZ - c * Time.time); //adding two waves according to direction vectors

		newPoint.x += amplitude * Mathf.Cos(f) / k;
		newPoint.y  = amplitude * Mathf.Sin(f) / k;
        newPoint.z += amplitude * Mathf.Cos(f) / k;

        return newPoint;
    }

}
