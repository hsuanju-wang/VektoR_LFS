using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrassGrow : MonoBehaviour
{
    public Material startMat;
    public Material endMat;
    public float duration = 3f;
    float startTime = 0f;
    Renderer rend;
    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();
        rend.material = startMat;
    }

    // Update is called once per frame
    void Update()
    {
        rend.material.Lerp(startMat, endMat, startTime/duration);
        startTime += Time.deltaTime;
    }
}
