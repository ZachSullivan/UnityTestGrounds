using UnityEngine;
using System.Collections;

public class Grow : MonoBehaviour {

    public float scale = 0.3f;
    public float growthRate = 1.0f;

    public float dissolveSpeed = 0.0f;
    float tParam = 0.0f;
    float valToBeLerped = 0.0f;


    Renderer dissolve;

	// Use this for initialization
	void Start () {
        dissolve = GetComponent<Renderer>();
        dissolve.material.shader = Shader.Find("Dissolve");
    }   
	
	// Update is called once per frame
	void Update () {

        //Check the status of the dissolve effect
        if (dissolve.material.GetFloat("_SliceAmount") >= 1) {
            //Once the dissolve effect has been completed, destroy the gameobject
            Destroy(this.gameObject);
        }

        //Increase the time parameter by both time elasped and speed factor (while < max shaderslice value)
        if (tParam < 1) {
            tParam += Time.deltaTime * dissolveSpeed;
        }
        valToBeLerped = Mathf.Lerp(0, 1, tParam);

        //Scale the gameobject overtime
        transform.localScale += new Vector3(0.1f, 0.1f, 0.1f) * Time.deltaTime * scale;

        //Apply dissolve effect
        dissolve.material.SetFloat("_SliceAmount", valToBeLerped);

        scale += growthRate * Time.deltaTime;
        
    }
}
